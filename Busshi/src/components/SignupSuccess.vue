<template>
  <div class="container">
    <div class="icon">
      <img src="@/assets/p1-victimbutton1_cut.png" alt="登録アイコン" />
    </div>
    <div class="message">
      Successed!!
    </div>
    <div class="button-container">
      <button @click="navigateToRole1">{{ buttonText1 }}</button>
    </div>
  </div>
</template>

<script setup>
import { useRouter } from 'vue-router';
const router = useRouter();
const buttonText1 = 'Sign in';

const navigateToRole1 = () => {
  router.push('/users/sign_in');
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
  padding: 20px; /* スマホ画面での余白を確保 */
  box-sizing: border-box;
}

.icon {
  margin-bottom: 20px;
}

.icon img {
  width: 40vw; /* 画面幅に応じて画像サイズを調整 */
  height: auto;
  border-radius: 50%;
}

.message {
  font-size: 6vw; /* 画面幅に基づいたフォントサイズ */
  margin-bottom: 30px;
}

.button-container {
  display: flex;
  justify-content: center;
  width: 100%;
}

button {
  padding: 15px 30px;
  font-size: 4vw; /* フォントサイズを画面幅に合わせて調整 */
  background-color: #000;
  color: #fff;
  border: none;
  border-radius: 25px;
  width: 80%; /* ボタン幅を画面幅に対して設定 */
}
</style>
