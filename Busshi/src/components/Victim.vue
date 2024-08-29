<template>
  <div>
    <!-- ログイン状態による表示制御 -->
    <div v-if="isAuthenticated">
      <p>Welcome, {{ currentUser.email }} {{ currentUser.age }} {{ currentUser.gender }}</p>
      <button @click="logout">Logout</button>
    </div>
    <div v-else>
      <button @click="$router.push('/users/sign_in')">Login</button>
    </div>

    <h1>楽天商品検索</h1>
    <input v-model="keyword" placeholder="商品を検索" />
    <button @click="searchProducts">検索</button>

    <!-- 検索結果の表示 -->
    <ul v-if="products.length > 0">
      <li v-for="product in products" :key="product.itemCode">
        <img :src="product.mediumImageUrls[0]" alt="商品画像" />
        <p>{{ product.itemName }}</p>
        <p>価格: {{ product.itemPrice }}円</p>
        <p>レビュー: {{ product.reviewAverage }}/5</p>
        <a :href="product.itemUrl" target="_blank">商品ページへ</a>

        <div class="desire-level-buttons">
          <button
            @click="saveDesireLevel(product, 3)"
            :disabled="isProductAlreadyRated(product)"
            :class="{'rated-button': isProductAlreadyRated(product)}"
          >
            今すぐほしい！！{{ isProductAlreadyRated(product) ? ' (設定済み)' : '' }}
          </button>
          <button
            @click="saveDesireLevel(product, 2)"
            :disabled="isProductAlreadyRated(product)"
            :class="{'rated-button': isProductAlreadyRated(product)}"
          >
            欲しいかも{{ isProductAlreadyRated(product) ? ' (設定済み)' : '' }}
          </button>
          <button
            @click="saveDesireLevel(product, 1)"
            :disabled="isProductAlreadyRated(product)"
            :class="{'rated-button': isProductAlreadyRated(product)}"
          >
            あったら嬉しい{{ isProductAlreadyRated(product) ? ' (設定済み)' : '' }}
          </button>
        </div>
      </li>
    </ul>
  </div>
</template>

<script>
import axios from 'axios';
import { mapGetters } from 'vuex';

export default {
  data() {
    return {
      keyword: '',
      products: [],  // 検索結果の商品リスト
      ratedProducts: []  // ユーザーが既に評価した商品のリスト
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
    async searchProducts() {
      try {
        const response = await axios.get('http://localhost:3000/products/search', {
          params: {
            keyword: this.keyword
          }
        });
        console.log(response.data);
        this.products = response.data;
      } catch (error) {
        console.error('APIリクエストに失敗しました:', error);
      }
    },

    async fetchRatedProducts() {
      try {
        const response = await axios.get('http://localhost:3000/user_products', {
          params: {
            user_id: this.currentUser.id
          }
        });
        this.ratedProducts = response.data.map(product => product.product_name);
      } catch (error) {
        console.error('既に評価された商品の取得に失敗しました:', error);
      }
    },

    isProductAlreadyRated(product) {
      return this.ratedProducts.includes(product.itemName);
    },

    async saveDesireLevel(product, level) {
      if (!this.currentUser) {
        console.error('ユーザーがログインしていません。');
        return;
      }

      try {
        const response = await axios.post('http://localhost:3000/user_products', {
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

        console.log('欲しさレベルが保存されました:', response.data);
        alert('欲しさレベルが保存されました');
        this.fetchRatedProducts();  // 保存後に評価された商品リストを更新
      } catch (error) {
        if (error.response && error.response.status === 422) {
          alert('既にこの商品には欲しさレベルが設定されています。');
        } else {
          console.error('データ保存エラー:', error.response ? error.response.data : error.message);
          alert('データ保存に失敗しました');
        }
      }
    }
  }
};
</script>

<style scoped>
ul {
  list-style-type: none;
  padding: 0;
}

li {
  margin: 10px 0;
}

img {
  max-width: 100px;
  height: auto;
}

.rated-button {
  background-color: #ccc;
  cursor: not-allowed;
}
</style>
