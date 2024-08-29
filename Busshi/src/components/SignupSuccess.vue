<template>
  <div class="container">
    <div class="icon">
      <img src="@/assets/p1-victimbutton1_cut.png" alt="登録アイコン" />
    </div>
    <div class="message">
      登録しました！
    </div>
    <div class="button-container">
      <button @click="navigateToRole1">{{ buttonText1 }}</button>
    </div>
  </div>
</template>

<script setup>
import { useRouter } from 'vue-router'; // Vue Routerをインポート
const router = useRouter();
const buttonText1 = 'サインインする';

const navigateToRole1 = () => {
  router.push('/users/sign_in'); // サインインのページに遷移
};
</script>

<style scoped>
.container {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  height: 100vh;
  text-align: center;
}

.icon {
  margin-bottom: 20px;
}

.icon img {
  width: 150px; /* 画像のサイズを調整 */
  height: auto;
  border-radius: 50%; /* 必要なら角丸を調整 */
}

.message {
  font-size: 24px;
  margin-bottom: 30px;
}

.button-container {
  display: flex;
  justify-content: center;
}

button {
  padding: 10px 20px;
  font-size: 16px;
  cursor: pointer;
  background-color: #000;
  color: #fff;
  border: none;
  border-radius: 25px;
}
</style>
