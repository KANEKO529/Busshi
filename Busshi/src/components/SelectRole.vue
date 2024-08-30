<template>
  <div class="container">
    <div class="app-name">
      <img src="@/assets/Weixin Image_20240829090829.png" alt="AppName" class="app-logo" />
    </div>
    <div class="button-container">
      <div @click="navigateToRole1" class="icon victim-icon">
        <p class="icon-text">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;victims</p>
      </div>
      <div @click="navigateToRole2" class="icon support-icon">
        <span class="icon-text">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;supporters</span>
      </div>
    </div>
    <div class="register-container">
      <button @click="navigateToRole3">{{ buttonText3 }}</button>
    </div>
  </div>
</template>

<script setup>
import { useRouter } from 'vue-router';
const router = useRouter();
const buttonText3 = 'Sign up';

const navigateToRole1 = () => {
  router.push('/users/sign_in');
};

const navigateToRole2 = () => {
  router.push('/role2');
};

const navigateToRole3 = () => {
  router.push('/register');
};
</script>

<style scoped>
/* 画面全体をカバーするコンテナ */
.container {
  display: flex;
  flex-direction: column;
  justify-content: flex-start; /* 上部に寄せる */
  align-items: center;
  min-height: 100vh; /* 画面全体に合わせる */
  text-align: center;
  padding-top: 0vh; /* ロゴ上部に余白を追加 */
}

/* ロゴとアプリ名のスタイル */
.app-name {
  margin-bottom: 0vh; /* ロゴとボタンの間に余白を設定 */
}

.app-logo {
  max-width: 60%;
  height: auto;
}

/* ボタンコンテナのスタイル */
.button-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  width: 100%;
  gap: 2vh; /* 各ボタンの間に余白を設定 */
  padding-left: 50px;
  padding-right: 50px;
}

/* ボタンのスタイル */
.icon {
  width: 110%; /* 幅を画面に対する割合で設定 */
  height: 20vh; /* 高さをビューポート高さの割合で設定 */
  display: flex;
  justify-content: center;
  align-items: center;
  color: #29155f;
  font-size: 2rem;
  font-weight: bold;
  background-size: contain;
  background-repeat: no-repeat;
  background-position: center;
  cursor: pointer;
}

.victim-icon {
  background-image: url('@/assets/p1-victimbutton1.png');
}

.support-icon {
  background-image: url('@/assets/p1-supportbutton.png');
}

/* 登録ボタンコンテナのスタイル */
.register-container {
  margin-top: 5vh; /* 上部に余白を設定 */
}

/* 登録ボタンのスタイル */
button {
  padding: 15px 30px;
  font-size: 1.5rem;
  background-color: #333;
  color: white;
  border: none;
  border-radius: 10px;
  cursor: pointer;
  transition: background-color 0.3s;
}

button:hover {
  background-color: #555;
}
</style>
