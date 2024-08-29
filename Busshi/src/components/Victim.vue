<template>
  <div>
    <nav class="navbar">
      <div class="app-name">
        <img src="@/assets/logo.png" alt="AppName" class="app-logo" />
      </div>

      <div class="search-bar">
        <input v-model="keyword" placeholder="keyword" />
        <button @click="searchProducts"><img src="@/assets/symbol064.png" alt="AppName" class="search" /></button>
      </div>
    </nav>

    <div>
      <div v-if="isAuthenticated" class="auth-info">
        <div>Welcome, {{ currentUser.email }}</div>
        <div class="button2">
          <button @click="toggleView" class="auth-button1">Toggle View</button>
          <button @click="logout" class="auth-button1">Logout</button>
          <router-link to="/role2">
            <button class="auth-button1">To Supporter</button>
          </router-link>
        </div>
      </div>

      <div v-else class="auth-info">
        <button @click="toggleView" class="auth-button1">Toggle View</button>
        <button @click="$router.push('/users/sign_in')" class="auth-button1">Login</button>
        <router-link to="/role2">
          <button class="auth-button1">To Supporter</button>
        </router-link>
      </div>
    </div>

    <div>
      <ul v-if="products.length > 0" :class="['product-list', { 'grid-view': isGridView }]">
        <li v-for="product in products" :key="product.itemCode" :class="['product-item', { 'grid-item': isGridView }]">
          <img :src="product.mediumImageUrls[0]" alt="商品画像" class="product-image" />
          <p>{{ product.itemName }}</p>
          <p>Price: {{ product.itemPrice }} yen</p>
          <p>Review: {{ product.reviewAverage }}/5</p>
          <a :href="product.itemUrl" target="_blank">To Product Page</a>

          <div class="desire-level-buttons">
            <button
              v-if="isProductAlreadyRated(product, 3)"
              @click="removeDesireLevel(product)"
              class="rated-button"
            >
              Remove Must have!!
            </button>
            <button
              v-else
              @click="saveDesireLevel(product, 3)"
              :class="{'rated-button': isProductAlreadyRated(product, 3)}"
            >
              Must have!!{{ isProductAlreadyRated(product, 3) ? ' (Already set)' : '' }}
            </button>

            <button
              v-if="isProductAlreadyRated(product, 2)"
              @click="removeDesireLevel(product)"
              class="rated-button"
            >
              Remove Would Like
            </button>
            <button
              v-else
              @click="saveDesireLevel(product, 2)"
              :class="{'rated-button': isProductAlreadyRated(product, 2)}"
            >
              Would Like{{ isProductAlreadyRated(product, 2) ? ' (Already set)' : '' }}
            </button>

            <button
              v-if="isProductAlreadyRated(product, 1)"
              @click="removeDesireLevel(product)"
              class="rated-button"
            >
              Remove Nice to Have
            </button>
            <button
              v-else
              @click="saveDesireLevel(product, 1)"
              :class="{'rated-button': isProductAlreadyRated(product, 1)}"
            >
              Nice to Have{{ isProductAlreadyRated(product, 1) ? ' (Already set)' : '' }}
            </button>
          </div>
        </li>
      </ul>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import { mapGetters } from 'vuex';

export default {
  data() {
    return {
      keyword: '',
      products: [],
      ratedProducts: [],
      isGridView: false, // 横並び表示のフラグを追加
    };
  },
  computed: {
    ...mapGetters(['isAuthenticated', 'currentUser'])
  },
  mounted() {
    if (this.isAuthenticated) {
      this.fetchRatedProducts();
    }
  },
  methods: {
    toggleView() {
      this.isGridView = !this.isGridView;
    },
    async searchProducts() {
      try {
        const response = await axios.get('http://localhost:3000/products/search', {
          params: { keyword: this.keyword }
        });
        this.products = response.data;
      } catch (error) {
        console.error('APIリクエストに失敗しました:', error);
      }
    },
    async fetchRatedProducts() {
  try {
    const response = await axios.get('http://localhost:3000/user_products', {
      params: { user_id: this.currentUser.id }
    });
    // Make sure to store the `id` from the `UserProduct`
    this.ratedProducts = response.data.map(product => ({
      id: product.id,  // Ensure id is stored
      productName: product.product_name,
      desireLevel: product.desire_level
    }));
  } catch (error) {
    console.error('既に評価された商品の取得に失敗しました:', error);
  }
},

    isProductAlreadyRated(product, level) {
      return this.ratedProducts.some(
        rated => rated.productName === product.itemName && rated.desireLevel === level
      );
    },
    async saveDesireLevel(product, level) {
      if (!this.isAuthenticated) {
        alert('ログインしてください');
        return;
      }

      try {
        await axios.post('http://localhost:3000/user_products', {
          user_product: {
            user_id: this.currentUser.id,
            product_name: product.itemName,
            item_url: product.itemUrl,
            image_url: product.mediumImageUrls[0],
            price: product.itemPrice,
            review_score: product.reviewAverage,
            desire_level: level,
            gender: this.currentUser.gender,
            age: this.currentUser.age,
            prefecture: this.currentUser.prefecture,
            city: this.currentUser.city
          }
        });

        alert('欲しさレベルが保存されました');
        this.fetchRatedProducts(); // 保存後に評価された商品リストを更新
      } catch (error) {
        if (error.response && error.response.status === 422) {
          alert('既にこの商品には欲しさレベルが設定されています。');
        } else {
          console.error('データ保存エラー:', error.response ? error.response.data : error.message);
          alert('データ保存に失敗しました');
        }
      }
    },
    async removeDesireLevel(product) {
  if (!this.isAuthenticated) {
    alert('ログインしてください');
    return;
  }

  // Find the UserProduct that matches the current product and desire level
  const ratedProduct = this.ratedProducts.find(rated => rated.productName === product.itemName);

  if (!ratedProduct) {
    alert('対象の商品が見つかりませんでした。');
    return;
  }

  try {
    await axios.delete(`http://localhost:3000/user_products/${ratedProduct.id}`);
    alert('欲しさレベルが削除されました');
    this.fetchRatedProducts();  // 更新された評価された商品リストを再取得
  } catch (error) {
    console.error('データ削除エラー:', error.response ? error.response.data : error.message);
    alert('データ削除に失敗しました');
  }
}

,
    logout() {
      this.$store.dispatch('logout');
      this.$router.push('/products/search');
    }
  }
};
</script>


<style scoped>

nav {
  height: 125px;
  background-color: #ffffff;
  /* padding: 0 20px; */
  display: flex;
  align-items: center;
  justify-content: space-between;
  border-bottom: 2px solid #ccc;
  box-sizing: border-box;
}

.search {
  width: 30px;
  height: 100%;
}


.app-name {
  /* margin-right: auto; */
  width: 125px;
  height: 125px;
  overflow: hidden;
}

.app-logo {
  padding: 10px;
  width: 100%;
  height: 100%;
  object-fit: cover; /* 画像をコンテナに合わせてカバーする */
  /* object-position:; 画像を中央に配置する */
}

.nav-links {
  display: flex;
  list-style: none;
}

.nav-links li {
  margin: 0 15px;
}

.auth-info {
  display: flex;
  align-items: center;
  width: 100%;
  justify-content: space-between; /* 左右に要素を配置 */
  /* gap: 10px; 要素間のスペースを調整 */
}

.button2 {
  display: flex;
  /* gap: 10px; ボタン間のスペースを調整 */
}



.auth-button {
  /* margin-left: 10px; */
  padding: 6px 12px;
  font-size: 14px;
  background-color: #007bff;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

.auth-button1 {
  /* margin-left: 10px; */
  padding: 6px 12px;
  font-size: 14px;
  background-color: #ffb26a;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

.auth-button:hover {
  background-color: #0056b3;
}


.search-bar {
  display: flex;
  align-items: center;
  margin-right: 10px;
}

.search-bar input {
  padding: 6px;
  font-size: 14px;
  /* margin-right: 10px; */
  border-radius: 4px;
  border: 1px solid #ccc;
}

.search-bar button {
  padding: 6px 12px;
  font-size: 14px;
  background-color: #ffffff;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

.search-bar button:hover {
  background-color: #ffffff;
}

ul.product-list {
  list-style-type: none;
  padding: 0;
  margin: 0 auto;
  max-width: 80%;
}

li.product-item {
  margin-bottom: 20px;
  background-color: hsl(33, 100%, 96%);
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  padding: 15px;
}

.product-image {
  max-width: 100%;
  margin-bottom: 10px;
}

.desire-level-buttons {
  display: flex;
  flex-direction: column;
}

.desire-level-buttons button {
  margin-top: 5px;
  padding: 6px 15px;
  font-size: 14px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

.desire-level-buttons .rated-button {
  background-color: gray;
  cursor: not-allowed;
}

.desire-level-buttons .rated-button:hover {
  background-color: gray;
}

.desire-level-buttons button:not(.rated-button) {
  background-color: #007bff;
  color: white;
}

.desire-level-buttons button:not(.rated-button):hover {
  background-color: #0056b3;
}

ul.product-list {
  list-style-type: none;
  padding: 0;
  margin: 0 auto;
  max-width: 80%;
  padding-top: 20px;
}

ul.product-list2 {
  list-style-type: none;
  padding: 0;
  margin: 0 auto;
  max-width: 95%;
}


li.product-item {
  margin-bottom: 20px;
  background-color: hsl(33, 100%, 96%);
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  padding: 15px;
}

ul.product-list.grid-view {
  display: flex;
  flex-wrap: wrap;
  justify-content: space-between;
}

li.product-item.grid-item {
  flex: 0 0 calc(50% - 20px); /* 横に2つ並べる場合 */
  margin-bottom: 20px;
  margin-right: 10px;
  margin-left: 10px;
}


</style>