<template>
  <div class="container">
    <div class="app-name">
      <img src="@/assets/Weixin Image_20240829090829.png" alt="AppName" class="app-logo" />
    </div>
    <div class="register-container">
      <h1>User Information</h1>

      <!-- エラーメッセージを表示 -->
      <div v-if="errors.length" class="error-messages">
        <ul>
          <li v-for="(error, index) in errors" :key="index">
            {{ error }}
          </li>
        </ul>
      </div>

      <form @submit.prevent="registerUser" class="register-form">
        <div class="input-group">
          <label for="email">Email</label>
          <input id="email" type="email" v-model="user.email" required>
        </div>
        <div class="input-group">
          <label for="password">Password</label>
          <input id="password" type="password" v-model="user.password" required>
        </div>

        <div class="input-group">
          <label for="gender">Sex</label>
          <select id="gender" v-model="user.gender">
            <option value="male">Male</option>
            <option value="female">Female</option>
            <option value="other">Others</option>
          </select>
        </div>

        <div class="input-group">
          <label for="age">Age</label>
          <input id="age" type="number" v-model="user.age" >
        </div>

        <div class="input-group">
          <label for="prefecture">Prefecture</label>
          <select id="prefecture" v-model="user.prefecture" @change="fetchCities">
            <option v-for="(prefecture, index) in prefectures" :key="index" :value="prefecture">
              {{ prefecture }}
            </option>
          </select>
        </div>

        <div class="input-group">
          <label for="city">City</label>
          <select id="city" v-model="user.city" v-if="cities.length > 0">
            <option v-for="(city, index) in cities" :key="index" :value="city">
              {{ city }}
            </option>
          </select>
          <input id="city" type="text" v-model="user.city">
        </div>

        <button type="submit" class="register-button">Sigh up</button>
      </form>
    </div>
  </div>
</template>

<script>
import { ref } from 'vue';
import { useRouter } from 'vue-router';
import { useStore } from 'vuex';
import axios from 'axios';

export default {
  setup() {
    const router = useRouter();
    const store = useStore();

    const user = ref({
      email: '',
      password: '',
      gender: '',
      age: null,
      prefecture: '',
      city: ''
    });
    const errors = ref([]);

    const prefectures = ref([]);
    const cities = ref([]);

    const fetchPrefectures = async () => {
      try {
        const response = await axios.get('https://geoapi.heartrails.com/api/json?method=getPrefectures');
        prefectures.value = response.data.response.prefecture;
      } catch (error) {
        console.error('Failed to fetch prefectures:', error);
      }
    };

    const fetchCities = async () => {
      const selectedPrefecture = user.value.prefecture;
      if (selectedPrefecture) {
        try {
          const response = await axios.get(`https://geoapi.heartrails.com/api/json?method=getCities&prefecture=${selectedPrefecture}`);
          cities.value = response.data.response.location.map(location => location.city);
        } catch (error) {
          console.error('Failed to fetch cities:', error);
        }
      }
    };

    const registerUser = async () => {
      errors.value = [];
      try {
        const response = await axios.post('http://localhost:3000/users', {
          user: user.value
        });
        store.dispatch('login', response.data.user);
        router.push('/register/success');
      } catch (error) {
        if (error.response && error.response.data.errors) {
          errors.value = error.response.data.errors;
        } else {
          console.error('登録エラー:', error);
        }
      }
    };

    fetchPrefectures();

    return {
      user,
      errors,
      prefectures,
      cities,
      registerUser,
      fetchCities
    };
  }
};
</script>

<style scoped>
/* 画面全体をカバーするコンテナ */
.container {
  display: flex;
  flex-direction: column;
  justify-content: flex-start; /* 上部に寄せる */
  align-items: center;
  height: 100vh;
  text-align: center;
  padding-top: 0vh; /* 必要に応じて調整 */
}

/* ロゴとアプリ名のスタイル */
.app-name {
  margin-bottom: 20px;
}

.app-logo {
  max-width: 60%;
  height: auto;
}

/* フォームのコンテナ */
.register-container {
  max-width: 380px;
  width: 80%;
  padding: 20px;
  background-color: #f9f9f9;
  border-radius: 10px;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
}

/* タイトル */
h1 {
  margin-bottom: 20px;
  font-size: 26px;
  color: #333;
}

/* エラーメッセージ */
.error-messages {
  color: red;
  margin-bottom: 20px;
  font-size: 14px;
}

/* フォームの各入力フィールドのスタイル */
.input-group {
  margin-bottom: 20px;
}

.input-group label {
  display: block;
  font-size: 16px;
  margin-bottom: 8px;
  text-align: left;
}

.input-group input,
.input-group select {
  width: 100%;
  padding: 12px;
  font-size: 16px;
  border: 1px solid #ccc;
  border-radius: 5px;
  box-sizing: border-box;
}

.input-group input:focus,
.input-group select:focus {
  border-color: #5b9bd5;
  outline: none;
}

/* 登録ボタン */
.register-button {
  width: 100%;
  padding: 14px;
  font-size: 18px;
  background-color: #007bff;
  color: white;
  border: none;
  border-radius: 5px;
  cursor: pointer;
  transition: background-color 0.3s;
}

.register-button:hover {
  background-color: #0056b3;
}

</style>
