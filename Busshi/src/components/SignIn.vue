<template>
  <div>
    <h1>サインイン</h1>
    <div v-if="errors.length">
      <ul>
        <li v-for="(error, index) in errors" :key="index" style="color: red;">
          {{ error }}
        </li>
      </ul>
    </div>
    <form @submit.prevent="signInUser">
      <input type="email" v-model="email" placeholder="メールアドレス" required>
      <input type="password" v-model="password" placeholder="パスワード" required>
      <button type="submit">サインイン</button>
    </form>
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