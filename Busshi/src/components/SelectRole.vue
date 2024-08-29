<template>
  <div class="AppName">
    <img src="@/assets/Weixin Image_20240829090829.png" alt="AppName" />
  </div>
  <div class="button-container">
    <div @click="navigateToRole1" class="icon victim-icon">
      <span>&nbsp;&nbsp;victims</span>
    </div>
    <div @click="navigateToRole2" class="icon support-icon">
      <span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;supporters</span>
    </div>
  </div>
  <div class="register-container">
    <button @click="navigateToRole3">{{ buttonText3 }}</button>
  </div>
</template>

<script setup>
import { useRouter } from 'vue-router'; // Vue Routerをインポート
const router = useRouter();
const buttonText3 = '登録';

const navigateToRole1 = () => {
  router.push('/users/sign_in'); // victimのページに遷移
};

const navigateToRole2 = () => {
  router.push('/role2'); // supporterのページに遷移
};

const navigateToRole3 = () => {
  router.push('/register'); // 登録のページに遷移
};
</script>

<style scoped>
.AppName {
  font-size: 0.001rem; /* より大きなフォントサイズを設定 */
  text-align: center;
  margin-top: 1vh; /* ビューポート高さの割合でマージンを設定 */
  font-weight: bold;
}

.button-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  margin-top: 0px;
}

.icon {
  width: 60%; /* 必要に応じて調整 */
  height: 15vh; /* 高さをビューポート高さの割合で設定 */
  display: flex;
  justify-content: center;
  align-items: center;
  color: #29155f;
  font-size: 1.5rem; /* フォントサイズを調整 */
  font-weight: bold;
  background-size: contain;
  background-repeat: no-repeat;
  background-position: center;
  margin-bottom: 20px;
  cursor: pointer;
}


.victim-icon {
  background-image: url('@/assets/p1-victimbutton1.png');
}

.support-icon {
  background-image: url('@/assets/p1-supportbutton.png');
}

.register-container {
  display: flex;
  justify-content: center;
  margin-top: 50px;
}

button {
  padding: 10px 20px;
  font-size: 20px;
  background-color: #333;
  color: white;
  border: none;
  border-radius: 5px;
  cursor: pointer;
}
</style>
