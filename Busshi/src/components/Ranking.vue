<template>
  <div>
    <div class="content-wrapper">
      <div class="content-container">
        <form @submit.prevent="applyFilters" class="filter-form">

          <div class="filter-group">

            <label for="gender">Sex</label>
            <select id="gender" v-model="filters.gender">
              <option value="">All</option>
              <option value="male">Male</option>
              <option value="female">Female</option>
              <option value="other">Others</option>
            </select>

            <label for="age">Age</label>
            <input id="age" type="number" v-model="filters.age" placeholder="20">

            <label for="prefecture">Prefecture</label>
            <select id="prefecture" v-model="filters.prefecture" @change="fetchCities(filters.prefecture)">
              <option value="">All</option>
              <option v-for="prefecture in prefectures" :key="prefecture" :value="prefecture">{{ prefecture }}</option>
            </select>

            <label for="city">City</label>
            <select id="city" v-model="filters.city">
              <option value="">All</option>
              <option v-for="city in cities" :key="city" :value="city">{{ city }}</option>
            </select>

          </div>

        </form>
      </div>

      <div class="content-container">
        <ul class="product-list">
          <li v-for="(item, index) in sortedProductCounts" :key="item.name" class="product-item">
            <p :style="rankStyle">{{ index + 1 }} </p>
            <img :src="item.image_url" alt="Product Image" class="product-image" />
            <p>{{ item.count }} favorites</p>
            <p>{{ item.name }}</p>
            <a :href="item.item_url" target="_blank">
              <button class="product-button">See the product page</button>
            </a>
          </li>
        </ul>
      </div>
    </div>
  </div>
</template>

<script>
import axios from "axios";

export default {
  data() {
    return {
      products: [],
      filters: {
        gender: "",
        age: null,
        prefecture: "",
        city: "",
      },
      prefectures: [],  // 県のリストを格納する配列
      cities: [],       // 市のリストを格納する配列
      rankStyle: {
        fontSize: "24px",
        fontWeight: "bold",
        color: "red",
      },
    };
  },
  created() {
    this.fetchPrefectures(); // コンポーネント作成時に県のリストを取得
    this.fetchProducts(); // 商品のリストを取得
  },
  methods: {
    async fetchPrefectures() {
      try {
        const response = await axios.get('https://geoapi.heartrails.com/api/json?method=getPrefectures');
        this.prefectures = response.data.response.prefecture;
      } catch (error) {
        console.error('Failed to fetch prefectures:', error);
      }
    },
    async fetchCities(prefecture) {
      if (prefecture) {
        try {
          const response = await axios.get(`https://geoapi.heartrails.com/api/json?method=getCities&prefecture=${prefecture}`);
          this.cities = response.data.response.location.map(location => location.city);
        } catch (error) {
          console.error('Failed to fetch cities:', error);
        }
      } else {
        this.cities = []; // 県が選択されていない場合は市のリストをクリア
      }
    },
    fetchProducts() {
      axios
        .get("http://localhost:3000/user_products")
        .then((response) => {
          this.products = Array.isArray(response.data)
            ? response.data
            : response.data?.data;
        })
        .catch((error) => {
          console.error("There was an error fetching the products!", error);
        });
    },
    applyFilters() {
      // フィルター適用時の処理
    },
  },
  computed: {
    filteredProducts() {
      return this.products.filter((product) => {
        return (
          (!this.filters.gender || product.gender === this.filters.gender) &&
          (!this.filters.age || product.age == this.filters.age) &&
          (!this.filters.prefecture || product.prefecture.includes(this.filters.prefecture)) &&
          (!this.filters.city || product.city.includes(this.filters.city))
        );
      });
    },
    filteredProductCounts() {
      const counts = {};
      const productDetails = {};

      this.filteredProducts.forEach((product) => {
        const name = product.product_name;
        if (counts[name]) {
          counts[name]++;
        } else {
          counts[name] = 1;
          productDetails[name] = {
            image_url: product.image_url,
            item_url: product.item_url,
            name: product.product_name,
          };
        }
      });

      return Object.keys(counts)
        .map((name) => ({
          name,
          count: counts[name],
          image_url: productDetails[name].image_url,
          item_url: productDetails[name].item_url,
        }))
        .sort((a, b) => b.count - a.count);
    },
    sortedProductCounts() {
      return this.filteredProductCounts;
    },
  },
};
</script>

<style scoped>
/* 全体レイアウトの改善 */
.content-wrapper {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding-top: 20px;
  
  /* max-width: 80%; */
}

/* ナビゲーションバーのスタイル */
.navbar {
  height: 125px;
  background-color: #ffffff;
  display: flex;
  align-items: center;
  justify-content: center;
  border-bottom: 2px solid #ccc;
  box-sizing: border-box;
}

/* アプリ名とロゴのスタイル */
.app-name {
  width: 125px;
  height: 125px;
  overflow: hidden;
}

.app-logo {
  padding: 10px;
  width: 100%;
  height: 100%;
  object-fit: cover;
}

/* フィルタフォームのスタイル */
.content-container {
  width: 95%;
  max-width: 800px;
  margin-bottom: 20px;
}

.filter-form {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 20px;
  padding: 20px;
  background-color: #f9f9f9;
  border-radius: 10px;
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
  /* width: 450px; */
}

.filter-group {
  display: flex;
  align-items: center;
  /* flex-direction: column; */
}

.filter-group label {
  margin-bottom: 5px;
  font-weight: bold;
}

.filter-group select,
.filter-group input {
  padding: 8px;
  border-radius: 4px;
  border: 1px solid #ccc;
  width: 50px;
}

/* 商品リストのスタイル */
.product-list {
  width: 100%;
  margin: 0;
  padding: 0;
  list-style-type: none;
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 20px;
}

.product-item {
  padding: 15px;
  background-color: hsl(33, 100%, 96%);
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  text-align: center;
}

.product-image {
  max-width: 100%;
  margin-bottom: 10px;
}

.product-button {
  padding: 10px 15px;
  font-size: 14px;
  background-color: #007bff;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

.product-button:hover {
  background-color: #0056b3;
}

</style>
