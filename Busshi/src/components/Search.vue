<template>
  <div>
    <div class="search-bar">
      <input v-model="keyword" placeholder="keyword" />
      <button @click="searchByKeyword"><img src="@/assets/symbol064.png" alt="AppName" class="search" /></button>
    </div>

    <ul v-if="products.length > 0" class="product-list">
      <li v-for="product in products" :key="product.itemCode" class="product-item">
        <!-- 画像が存在する場合、そのURLを表示、存在しない場合デフォルト画像を表示 -->
        
        <div class="container-left">
          <img :src="productImageUrl(product.mediumImageUrls[0])" alt="商品画像" class="product-image" />
        </div>

        <div class="container-center">
          <div class="item-name">
            <p>{{ product.itemName }}</p>
          </div>
          <div class="item-info">
            <div class="item-review">
              <p v-if="product.reviewAverage == 5.0">
                <img src="@/assets/star5.jpg" alt="AppName" class="review-logo" />
                ({{ product.reviewAverage }})
              </p>
              <p v-else-if="product.reviewAverage >= 4.5 && product.reviewAverage < 5.0">
                <img src="@/assets/star4half.jpg" alt="AppName" class="review-logo" />
                ({{ product.reviewAverage }})
              </p>
              <p v-else-if="product.reviewAverage >= 4.0 && product.reviewAverage < 4.5">
                <img src="@/assets/star4.jpg" alt="AppName" class="review-logo" />
                ({{ product.reviewAverage }})
              </p>
              <p v-else-if="product.reviewAverage >= 3.5 && product.reviewAverage < 4.0">
                <img src="@/assets/star3half.jpg" alt="AppName" class="review-logo" />
                ({{ product.reviewAverage }})
              </p>              
              <p v-else-if="product.reviewAverage >= 3.0 && product.reviewAverage < 3.5">
                <img src="@/assets/star3.jpg" alt="AppName" class="review-logo" />
                ({{ product.reviewAverage }})
              </p>              
              <p v-else-if="product.reviewAverage >= 2.5 && product.reviewAverage < 3.0">
                <img src="@/assets/star2half.jpg" alt="AppName" class="review-logo" />
                ({{ product.reviewAverage }})
              </p>              
              <p v-else-if="product.reviewAverage >= 2.0 && product.reviewAverage < 2.5">
                <img src="@/assets/star2.jpg" alt="AppName" class="review-logo" />
                ({{ product.reviewAverage }})
              </p>
              <p v-else-if="product.reviewAverage >= 1.5 && product.reviewAverage < 2.0">
                <img src="@/assets/star1half.jpg" alt="AppName" class="review-logo" />
                ({{ product.reviewAverage }})
              </p>
              <p v-else-if="product.reviewAverage >= 1.0 && product.reviewAverage < 1.5">
                <img src="@/assets/star1.jpg" alt="AppName" class="review-logo" />
                ({{ product.reviewAverage }})
              </p>
              <p v-else-if="product.reviewAverage >= 0.5 && product.reviewAverage < 1.0">
                <img src="@/assets/star0half.jpg" alt="AppName" class="review-logo" />
                ({{ product.reviewAverage }})
              </p>
              <p v-else-if="product.reviewAverage >= 0.0 && product.reviewAverage < 0.5">
                <img src="@/assets/0.jpg" alt="AppName" class="review-logo" />
                ({{ product.reviewAverage }})
              </p>
            </div>
            <div class="item-price">
              <p><span class="font-size">{{ product.itemPrice.toLocaleString() }} </span> yen</p>
            </div>

          </div>
        </div>

        <div  class="container-right">
          <div class="desire-level-buttons">
            <button @click="saveDesireLevel(product, 3)" class="desire-button">Must</button>
            <button @click="saveDesireLevel(product, 2)" class="desire-button">Want</button>
            <button @click="saveDesireLevel(product, 1)" class="desire-button">Wish</button>
          </div>
          <a :href="product.itemUrl" target="_blank">View</a>
        </div>

      </li>
    </ul>
  </div>
</template>

<script>
import axios from 'axios';
import { mapGetters } from 'vuex'; // mapGetters用
import defaultImage from '@/assets/default-image.png'; // デフォルト画像をインポート

export default {
  data() {
    return {
      keyword: '',
      genreId: null,
      products: [] // 商品リスト
    };
  },
  computed: {
    ...mapGetters(['isAuthenticated', 'currentUser'])
  },
  watch: {
    // URLのクエリパラメータが変わったときに検索を行う
    '$route.query.genreId': function (newGenreId) {
      this.genreId = newGenreId;
      this.searchProducts();
    }
  },
  mounted() {
    // URLのクエリパラメータからgenreIdを取得する
    this.genreId = this.$route.query.genreId;
    if (this.genreId) {
      this.searchProducts();
    }
  },
  methods: {
    productImageUrl(imageUrl) {
      // URLが存在するかを確認する（ここで非同期処理は行えないため、単純にURLの有無を確認）
      return imageUrl || defaultImage;
    },
    async searchProducts() {
      try {
        const response = await axios.get('http://localhost:3000/products/search', {
          params: {
            genreId: this.genreId,
            keyword: this.keyword || undefined // キーワードがあれば追加、なければ無視
          }
        });
        this.products = response.data;
      } catch (error) {
        console.error('APIリクエストに失敗しました:', error);
      }
    },

    async searchByKeyword() {
      this.genreId = null; // ジャンルIDをリセット
      this.searchProducts();
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

        alert('欲しいBusshiが保存されました');
      } catch (error) {
        console.error('Error saving desire level:', error.response ? error.response.data : error.message);
        alert('データ保存に失敗しました');
      }
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
  padding-left: 20px;
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


.product-image {
  max-width: 128px;
  margin-bottom: 10px;
}

.container-left {
  width: 128px;
}

.container-center {
  padding-left: 10px;
  width: 80%;
  display: flex;
  flex-direction: column;
}

.item-name {
  width: 100%;
  height: 70%
}

.item-info {
  display: flex;
  height: 30%;
}

.item-price {

  width: 50%;
  text-align: right;
  padding-right: 20px;
}

.font-size {
  font-size: 30px;
  color: red;
}

.item-review {
  width: 50%;
}

.review-logo {
  padding-top: 0px;
  max-width: 100px;
}

.container-right {
  width: 10%;
  
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
  max-width: 90%;
  padding-top: 20px;
}

ul.product-list2 {
  list-style-type: none;
  padding: 0;
  margin: 0 auto;
  max-width: 95%;
}
/* 
li.product-item {
  margin-bottom: 20px;
  background-color: white;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(197, 145, 145, 0.1);
  padding: 15px;

} */

li.product-item {
  margin-bottom: 20px;
  background-color: hsl(0, 0%, 100%);
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.5);
  padding: 15px;
  height: 160px;
  display: flex;
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