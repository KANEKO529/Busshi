<template>
  <div>
    <nav class="navbar">
      <div class="app-name">
        <img src="@/assets/logo.png" alt="AppName" class="app-logo" />
      </div>
      <div class="content-container">
        <form @submit.prevent="applyFilters" class="filter-form">
          <div class="filter-group">
            <label for="gender">Sex</label>
            <select id="gender" v-model="filters.gender">
              <option value="">All</option>
              <option value="male">Male</option>
              <option value="female">FeMale</option>
              <option value="other">Others</option>
            </select>
          </div>

          <div class="filter-group">
            <label for="ageGroup">Age</label>
            <select id="ageGroup" v-model="filters.ageGroup">
              <option value="">All</option>
              <option value="teens">10s</option>
              <option value="twenties">20s</option>
              <option value="thirties">30s</option>
              <option value="forties">40s</option>
              <option value="fifties">50s</option>
              <option value="sixties_and_above">More 60s</option>
            </select>
          </div>

          <div class="filter-group">
            <label for="prefecture">Prefecture</label>
            <select id="prefecture" v-model="filters.prefecture" @change="fetchCities">
              <option v-for="(prefecture, index) in prefectures" :key="index" :value="prefecture">
                {{ prefecture }}
              </option>
            </select>
          </div>

          <div class="filter-group">
            <label for="city">City</label>
            <select id="city" v-model="filters.city" v-if="cities.length > 0">
              <option v-for="(city, index) in cities" :key="index" :value="city">
                {{ city }}
              </option>
            </select>
          </div>
        </form>
      </div>
    </nav>

    <div class="auth-info">
      <router-link to="/products/search">
        <button class="auth-button1">To Victim</button>
      </router-link>
    </div>

    <div>
      <ul class="product-list">
        <li v-for="(item, index) in sortedProductCounts" :key="item.name" class="product-item">
          <p :style="rankStyle">{{ index + 1 }} </p>
          <img :src="item.image_url" alt="Product Image" class="product-image" />
          <!-- <p>{{ item.count }} people favorite．</p> -->

          <p>{{ item.name }}</p>
          <p>Must Have!! : {{ item.level3_count }} people</p>
          <p>Would Like : {{ item.level2_count }} people</p>
          <p>Nice  to Have : {{ item.level1_count }} people</p>
          <a :href="item.item_url" target="_blank">
            <button class="product-button">See the product Page</button>
          </a>
          <hr>
        </li>
      </ul>
    </div>
  </div>
</template>

<script>
import { ref, computed, onMounted } from 'vue';
import axios from 'axios';

export default {
  setup() {
    const products = ref([]);
    const filters = ref({
      gender: '',
      ageGroup: '',
      prefecture: '',
      city: ''
    });

    const rankStyle = {
      fontSize: '40px',
      fontWeight: 'bold',
      color: 'red',
      fontFamily: '"Arial", sans-serif'
    };

    const prefectures = ref([]);
    const cities = ref([]);

    const fetchPrefectures = async () => {
      try {
        const response = await axios.get('https://geoapi.heartrails.com/api/json?method=getPrefectures');
        prefectures.value = ['全て', ...response.data.response.prefecture];
      } catch (error) {
        console.error('Failed to fetch prefectures:', error);
      }
    };

    const fetchCities = async () => {
      const selectedPrefecture = filters.value.prefecture;
      if (selectedPrefecture && selectedPrefecture !== '全て') {
        try {
          const response = await axios.get(`https://geoapi.heartrails.com/api/json?method=getCities&prefecture=${selectedPrefecture}`);
          cities.value = ['全て', ...response.data.response.location.map(location => location.city)];
        } catch (error) {
          console.error('Failed to fetch cities:', error);
        }
      } else {
        cities.value = ['全て'];
      }
    };

    const fetchRankedProducts = async () => {
  try {
    const response = await axios.get('http://localhost:3000/user_products', {
      params: {
        gender: filters.value.gender,
        age_group: filters.value.ageGroup,
        prefecture: filters.value.prefecture,
        city: filters.value.city
      }
    });

    console.log('Filtered API Response:', response.data);

    console.log('API Response:', response.data); // APIのレスポンスを確認

    const weightedProductCounts = {};

    response.data.forEach(product => {
      const name = product.product_name;

      console.log(`Product: ${name}, Desire Level: ${product.desire_level}`); // Desire Levelの値を確認


      if (!weightedProductCounts[name]) {
        weightedProductCounts[name] = {
          name: product.product_name,
          image_url: product.image_url,
          item_url: product.item_url,
          weighted_score: 0,
          level1_count: 0,
          level2_count: 0,
          level3_count: 0
        };
      }


      if (product.desire_level === 1) {
        weightedProductCounts[name].weighted_score += 1;
        weightedProductCounts[name].level1_count += 1;
        console.log(`Incremented level1_count for ${name}`);
      } else if (product.desire_level === 2) {
        weightedProductCounts[name].weighted_score += 2;
        weightedProductCounts[name].level2_count += 1;
        console.log(`Incremented level2_count for ${name}`);
      } else if (product.desire_level === 3) {
        weightedProductCounts[name].weighted_score += 3;
        weightedProductCounts[name].level3_count += 1;
        console.log(`Incremented level3_count for ${name}`);
      }
    });

    products.value = Object.values(weightedProductCounts).sort((a, b) => b.weighted_score - a.weighted_score);

    console.log('Filtered Products after applying filters:', products.value);
    console.log('Weighted and Filtered products:', products.value);

  } catch (error) {
    console.error("There was an error fetching the weighted products!", error);
  }
};


    const sortedProductCounts = computed(() => products.value);

    const applyFilters = () => {
      console.log('Applying filters with:', filters.value);
      fetchRankedProducts();  // フィルタを適用して再取得
    };

    onMounted(() => {
      fetchPrefectures();
      fetchRankedProducts();
    });

    return {
      filters,
      prefectures,
      cities,
      rankStyle,
      sortedProductCounts,
      fetchCities,
      applyFilters
    };
  }
};
</script>



<style scoped>
/* ナビゲーションバーのスタイル */
.navbar {
  height: 125px;
  background-color: #ffffff;
  display: flex;
  align-items: center;
  justify-content: space-between;
  border-bottom: 2px solid #ccc;
  padding: 0 20px;
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

/* コンテンツコンテナのスタイル */
.content-container {
  display: flex;
  justify-content: center;
  /* align-items: center; */
  /* width: 100%; */
  /* margin: 10px; */
  padding: 10px;
}

/* フィルタフォームのスタイル */
.filter-form {
  display: grid;
  grid-template-columns: 1fr 1fr; /* 2列レイアウト */
  gap: 5px; /* 各フィルター間の隙間 */
  width: 100%; /* 必要に応じて幅を調整 */
  max-width: 600px; /* コンテナの最大幅を指定 */
}

.filter-group {
  display: flex;
  flex-direction: column;
  /* width: 50px; */
  /* height: 50px; */
}

.filter-group label {
  font-weight: bold;
  /* margin-bottom: 5px; */
}

.filter-group select {
  padding: 5px;
  border-radius: 4px;
  border: 1px solid #ccc;
}

/* 認証情報とボタンのスタイル */
.auth-info {
  display: flex;
  justify-content: flex-end;
}

.auth-button {
  padding: 8px 15px;
  font-size: 14px;
  background-color: #007bff;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  text-decoration: none;
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

/* 商品リストのスタイル */
.product-list {
  width: 80%;
  margin: 20px auto;
  padding: 0;
  list-style-type: none;
}

.product-item {
  margin-bottom: 20px;
  padding: 15px;
  background-color: hsl(33, 100%, 96%);
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.product-image {
  max-width: 100%;
  margin-bottom: 10px;
}

.product-button {
  padding: 6px 15px;
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

hr {
  border: none;
  border-top: 1px solid #ddd;
  margin: 20px 0;
}

</style>