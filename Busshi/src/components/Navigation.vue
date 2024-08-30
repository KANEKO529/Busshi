<template>

    <nav class="navbar">
        <div class="app-name">
            <img src="@/assets/logo.png" alt="AppName" class="app-logo" />
        </div>

        <!-- isAuthenticatedはstore.jsにある -->
        <div v-if="isAuthenticated" class="auth-info">
            <div>Welcome, {{ currentUser.email }}</div>
            <div class="button2">
            <button @click="logout" class="auth-button1">Logout</button>
            </div>
        </div>
        <div v-else class="auth-info">
            <button @click="$router.push('/signin')" class="auth-button1">Login</button>
        </div>
    </nav>

</template>

<script>
import { mapGetters } from 'vuex';//mapgetters用

export default {
    computed: {
    ...mapGetters(['isAuthenticated', 'currentUser'])
  }

}

</script>

<style scoped>

nav {
    height: 125px;
    /* background-color: #ffffff; */
    /* padding: 0 20px; */
    display: flex;
    align-items: center;
    justify-content: space-between;
    border-bottom: 2px solid #000000;
    box-sizing: border-box;
}

.app-name {
  /* margin-right: auto; */
  width: 125px;
  height: 125px;
  overflow: hidden;
}

.app-logo {
  padding: 10px;
  width: 100%;
  height: 100%;
  object-fit: cover; /* 画像をコンテナに合わせてカバーする */
  /* object-position:; 画像を中央に配置する */
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

</style>