<template>
  <div class="container">
    <div class="app-name">
      <img src="@/assets/Weixin Image_20240829090829.png" alt="AppName" class="app-logo" />
    </div>
    <div class="signin-container">
      <h1>Sign in</h1>
      <div v-if="errors.length" class="error-messages">
        <ul>
          <li v-for="(error, index) in errors" :key="index">
            {{ error }}
          </li>
        </ul>
      </div>
      <form @submit.prevent="signInUser" class="signin-form">
        <div class="input-group">
          <label for="email">Email</label>
          <input type="email" id="email" v-model="email">
        </div>
        <div class="input-group">
          <label for="password">Password</label>
          <input type="password" id="password" v-model="password"
        </div>
        <button type="submit" class="signin-button">Sign in</button>
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
    const email = ref('');
    const password = ref('');
    const errors = ref([]);

    const signInUser = async () => {
      errors.value = [];

      try {
        const response = await axios.post('http://localhost:3000/users/sign_in', {
          user: {
            email: email.value,
            password: password.value
          }
        });
        console.log('サインイン成功:', response.data);
        
        // ユーザー情報をVuexに保存
        if (response.data.user) {
          store.dispatch('login', response.data.user);
          router.push('/products/search'); // リダイレクト先
        } else {
          console.error('ユーザーデータが取得できませんでした:', response.data);
          errors.value.push('ユーザーデータが取得できませんでした。');
        }
      } catch (error) {
        console.error('サインインエラー:', error);
        if (error.response && error.response.data && error.response.data.error) {
          errors.value.push(error.response.data.error);
        } else {
          errors.value.push('メールアドレスまたはパスワードが正しくありません。');
        }
      }
    };

    return { email, password, errors, signInUser };
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

/* サインインフォームのスタイル */
.signin-container {

  max-width: 500px;
  width: 80%;
  padding: 20px;
  background-color: hsl(33, 100%, 96%);
  border-radius: 10px;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
}

h1 {
  margin-bottom: 20px;
  font-size: 26px;
  color: #333;
}

.error-messages {
  color: red;
  margin-bottom: 20px;
  font-size: 14px;
}

.signin-form .input-group {
  margin-bottom: 20px;
}

.input-group label {
  display: block;
  font-size: 16px;
  margin-bottom: 8px;
  text-align: left;
}

.input-group input {
  width: 100%;
  padding: 12px;
  font-size: 16px;
  border: 1px solid #ccc;
  border-radius: 5px;
  box-sizing: border-box;
}

.signin-button {
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

.signin-button:hover {
  background-color: #0056b3;
}
</style>
