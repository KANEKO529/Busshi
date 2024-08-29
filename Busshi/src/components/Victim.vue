<template>
  <div>

    <div v-if="isAuthenticated">
      <p>Welcome, {{ currentUser.email }} {{ currentUser.age }} {{ currentUser.gender }}</p> <!-- ここでメールアドレスを表示 -->
      <button @click="logout">Logout</button>
    </div>

    <div v-else>
      <button @click="$router.push('/users/sign_in')">Login</button>
    </div>

    <h1>楽天商品検索</h1>
    <input v-model="keyword" placeholder="商品を検索" />
    <button @click="searchProducts">検索</button>

    <ul v-if="products.length > 0">
      <li v-for="product in products" :key="product.itemCode">
        <img :src="product.mediumImageUrls[0]" alt="商品画像" />
        <p>{{ product.itemName }}</p>
        <p>価格: {{ product.itemPrice }}円</p>
        <p>レビュー: {{ product.reviewAverage }}/5</p>
        <p>itemcode: {{ product.itemCode }}</p>
        <a :href="product.itemUrl" target="_blank">商品ページへ</a>

        <div class="desire-level-buttons">
          <button @click="saveDesireLevel(product, 3)">今すぐほしい！！</button>
          <button @click="saveDesireLevel(product, 2)">欲しいかも</button>
          <button @click="saveDesireLevel(product, 1)">あったら嬉しい</button>
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
      products: []
    };
  },
  computed: {
    ...mapGetters(['isAuthenticated', 'currentUser'])
  },
  mounted() {
    console.log('現在のユーザー:', this.currentUser); // ユーザー情報が正しく表示されるはずです
    console.log('認証状態:', this.isAuthenticated); // 認証状態が正しいか確認
  },
  methods: {
    async searchProducts() {
      try {
        const response = await axios.get('http://localhost:3000/products/search', {
          params: {
            keyword: this.keyword
          }
        });
        console.log(response.data);  // レスポンスを確認
        this.products = response.data;
      } catch (error) {
        console.error('APIリクエストに失敗しました:', error);
      }
    },

    logout() {
      this.$store.dispatch('logout');
      this.$router.push('/products/search');
    },

    async saveDesireLevel(product, level) {
      console.log('現在のユーザー:', this.currentUser); // 追加：ユーザー情報をログに表示
      console.log('保存する商品データ:', product); // 商品データをログに表示

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
        city: this.currentUser.city,
        item_code: product.itemCode
      }
});

    console.log('欲しさレベルが保存されました:', response.data);
    console.log('保存された商品データ:', {
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
        city: this.currentUser.city,
        item_code: product.itemCode
      });
    console.log('送信するデータ:', {
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
        city: this.currentUser.city,
        item_code: product.itemCode
  }
});
    alert('欲しさレベルが保存されました');
  } catch (error) {
    console.error('Error saving desire level:', error.response ? error.response.data : error.message);
    alert('データ保存に失敗しました');
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
</style>
