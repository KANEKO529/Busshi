<template>
  <div>
    <h1>User Products</h1>
    <!-- コンテナ全体を横並びにするためのラッパー -->
    <div class="content-container">
      <!-- フィルタリングフォーム -->
      <form @submit.prevent="applyFilters">
        <div>
          <label for="gender">性別:</label>
          <select id="gender" v-model="filters.gender">
            <option value="">全て</option>
            <option value="male">男性</option>
            <option value="female">女性</option>
            <option value="other">その他</option>
          </select>
        </div>

        <div>
          <label for="ageGroup">年齢層:</label>
          <select id="ageGroup" v-model="filters.ageGroup">
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
          <select id="prefecture" v-model="filters.prefecture" @change="fetchCities">
            <option v-for="(prefecture, index) in prefectures" :key="index" :value="prefecture">
              {{ prefecture }}
            </option>
          </select>
        </div>

        <div>
          <label for="city">市区町村:</label>
          <select id="city" v-model="filters.city" v-if="cities.length > 0">
            <option v-for="(city, index) in cities" :key="index" :value="city">
              {{ city }}
            </option>
          </select>
        </div>
      </form>

      <!-- フィルタリング結果の表示 -->
      <ul>
        <li v-for="(item, index) in sortedProductCounts" :key="item.name" style="margin-bottom: 20px;">
          <p :style="rankStyle">{{ index + 1 }} </p>
          <img :src="item.image_url" alt="Product Image" style="max-width: 300px; margin-bottom: 10px;" />
          <br>
          <p>{{ item.count }} 回お気に入りに入りました．</p>
          <p>{{ item.name }}</p>
          <p>レベル1: {{ item.level1_count }} 人</p>
          <p>レベル2: {{ item.level2_count }} 人</p>
          <p>レベル3: {{ item.level3_count }} 人</p>
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
        console.log('Prefectures API Response:', response.data); // デバッグ用
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
          console.log('Cities API Response:', response.data); // デバッグ用
          cities.value = ['全て', ...response.data.response.location.map(location => location.city)];
        } catch (error) {
          console.error('Failed to fetch cities:', error);
        }
      } else {
        cities.value = ['全て']; // 都道府県が「全て」の場合は市区町村も「全て」のみ
      }
    };

    const fetchProducts = async () => {
      try {
        const response = await axios.get('http://localhost:3000/user_products', {
          params: {
            age_group: filters.value.ageGroup // 年齢層フィルタを追加
          }
        });
        products.value = Array.isArray(response.data) ? response.data : response.data?.data;
      } catch (error) {
        console.error("There was an error fetching the products!", error);
      }
    };

    const filteredProducts = computed(() => {
      return products.value.filter(product => {
        return (
          (!filters.value.gender || filters.value.gender === '全て' || product.gender === filters.value.gender) &&
          (!filters.value.prefecture || filters.value.prefecture === '全て' || product.prefecture.includes(filters.value.prefecture)) &&
          (!filters.value.city || filters.value.city === '全て' || product.city.includes(filters.value.city))
        );
      });
    });

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

    onMounted(() => {
      fetchProducts();
      fetchPrefectures();
    });

    return {
      filters,
      prefectures,
      cities,
      rankStyle,
      sortedProductCounts,
      fetchCities,
      applyFilters() {
        fetchProducts();
      }
    };
  }
};
</script>

<style>
.content-container {
  display: flex;
  justify-content: space-between;
}

.filter-form {
  flex: 1;
  margin-right: 20px;
}

.product-list {
  flex: 3;
  list-style-type: none;
  padding: 0;
}

.product-item {
  margin-bottom: 20px;
}

.product-image {
  max-width: 300px;
  margin-bottom: 10px;
}

.product-button {
  padding: 10px 20px;
  font-size: 16px;
}
</style>
