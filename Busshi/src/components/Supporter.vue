<template>
  <div>
    <h1>User Products</h1>

    <div class="auth-info">
      <router-link to="/products/search">
        <button class="auth-button">To Victim</button>
      </router-link>
    </div>

    <div class="content-container">
      <form @submit.prevent="applyFilters">
        <div>
  <label for="gender">性別:</label>
  <select id="gender" v-model="filters.gender">  <!-- id="gender" を追加 -->
    <option value="">全て</option>
    <option value="male">男性</option>
    <option value="female">女性</option>
    <option value="other">その他</option>
  </select>
</div>

<div>
  <label for="ageGroup">年齢層:</label>
  <select id="ageGroup" v-model="filters.ageGroup">  <!-- id="ageGroup" を追加 -->
    <option value="">全て</option>
    <option value="teens">10代</option>
    <option value="twenties">20代</option>
    <option value="thirties">30代</option>
    <option value="forties">40代</option>
    <option value="fifties">50代</option>
    <option value="sixties_and_above">60代以上</option>
  </select>
</div>

<div>
  <label for="prefecture">都道府県:</label>
  <select id="prefecture" v-model="filters.prefecture" @change="fetchCities">  <!-- id="prefecture" を追加 -->
    <option v-for="(prefecture, index) in prefectures" :key="index" :value="prefecture">
      {{ prefecture }}
    </option>
  </select>
</div>

<div>
  <label for="city">市区町村:</label>
  <select id="city" v-model="filters.city" v-if="cities.length > 0">  <!-- id="city" を追加 -->
    <option v-for="(city, index) in cities" :key="index" :value="city">
      {{ city }}
    </option>
  </select>
</div>

      </form>

      <ul>
        <li v-for="(item, index) in sortedProductCounts" :key="item.name" style="margin-bottom: 20px;">
          <p :style="rankStyle">{{ index + 1 }} </p>
          <img :src="item.image_url" alt="Product Image" style="max-width: 300px; margin-bottom: 10px;" />
          <br>
          <p>{{ item.count }} 回お気に入りに入りました．</p>
          <p>{{ item.name }}</p>
          <p>今すぐほしい！！ {{ item.level3_count }} 人</p>
          <p>ほしいかも {{ item.level2_count }} 人</p>

          <p>あったらうれしい {{ item.level1_count }} 人</p>
          <a :href="item.item_url" target="_blank">
            <button style="padding: 6px 15px; font-size: 10px;">商品ページを見る</button>
          </a>
          <p>
            ----------------------
          </p>
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
      ageGroup: '', // 年齢層フィルタを追加
      prefecture: '',
      city: ''
    });
    const rankStyle = {
      fontSize: '24px',
      fontWeight: 'bold',
      color: 'red'
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

    const fetchProducts = async () => {
  console.log('Gender filter:', filters.value.gender); // 性別フィルタの確認
  console.log('Age Group filter:', filters.value.ageGroup); // 年齢層フィルタの確認
  console.log('Prefecture filter:', filters.value.prefecture); // 都道府県フィルタの確認
  console.log('City filter:', filters.value.city); // 市区町村フィルタの確認

  try {
    const response = await axios.get('http://localhost:3000/user_products', {
      params: {
        gender: filters.value.gender,
        age_group: filters.value.ageGroup, // 年齢層フィルタを送信
        prefecture: filters.value.prefecture,
        city: filters.value.city
      }
    });
    products.value = Array.isArray(response.data) ? response.data : response.data?.data;
    console.log('Filtered products:', products.value); // フィルタリングされた商品をログに出力
  } catch (error) {
    console.error("There was an error fetching the products!", error);
  }
};

const checkAgeGroup = (age, ageGroup) => {
  switch (ageGroup) {
    case 'teens':
      return age >= 10 && age <= 19;
    case 'twenties':
      return age >= 20 && age <= 29;
    case 'thirties':
      return age >= 30 && age <= 39;
    case 'forties':
      return age >= 40 && age <= 49;
    case 'fifties':
      return age >= 50 && age <= 59;
    case 'sixties_and_above':
      return age >= 60;
    default:
      return true;
  }
};

const filteredProducts = computed(() => {
  return products.value.filter(product => {
    return (
      (!filters.value.gender || filters.value.gender === '全て' || product.gender === filters.value.gender) &&
      (!filters.value.ageGroup || filters.value.ageGroup === '全て' || checkAgeGroup(product.age, filters.value.ageGroup)) &&
      (!filters.value.prefecture || filters.value.prefecture === '全て' || product.prefecture.includes(filters.value.prefecture)) &&
      (!filters.value.city || filters.value.city === '全て' || product.city.includes(filters.value.city))
    );
  });
})

    const filteredProductCounts = computed(() => {
      const productCounts = {};

      filteredProducts.value.forEach(product => {
        const name = product.product_name;

        if (!productCounts[name]) {
          productCounts[name] = {
            name: product.product_name,
            image_url: product.image_url,
            item_url: product.item_url,
            level1_count: 0,
            level2_count: 0,
            level3_count: 0
          };
        }

        // 欲しさレベルに応じてカウントを増加
        if (product.desire_level === 1) {
          productCounts[name].level1_count += 1;
        } else if (product.desire_level === 2) {
          productCounts[name].level2_count += 1;
        } else if (product.desire_level === 3) {
          productCounts[name].level3_count += 1;
        }
      });

      return Object.values(productCounts).map(product => ({
        ...product,
        count: product.level1_count + product.level2_count + product.level3_count
      })).sort((a, b) => b.count - a.count);
    });

    const sortedProductCounts = computed(() => filteredProductCounts.value);

    const applyFilters = () => {
  console.log('Applying filters with:', filters.value);
  fetchProducts();  // フィルタを適用して再取得
};

    onMounted(() => {
      fetchPrefectures();  // 都道府県データを取得
      applyFilters();  // 初期状態でフィルタを適用
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

<style>
/* フィルタリングフォームを上部に固定 */
.filter-form {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  background-color: white;
  padding: 10px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  z-index: 1000;
}

/* コンテンツコンテナのスタイル */
.content-container {
  display: flex;
  justify-content: center;
  margin-top: 150px; /* フィルタリングフォームの高さを考慮して余白を設定 */
}

/* フィルタリング結果のリストのスタイル */
.product-list {
  width: 430px; /* 横幅を430pxに設定 */
  list-style-type: none;
  padding: 0;
}

.product-item {
  margin-bottom: 20px;
  padding: 15px;
  background-color: #f8f9fa; /* 背景色を追加 */
  border-radius: 8px; /* 角を丸くして見やすくする */
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1); /* 軽い影を追加して浮き上がらせる */
}

.product-image {
  max-width: 100%;
  margin-bottom: 10px;
}

.product-button {
  padding: 6px 15px;
  font-size: 10px;
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