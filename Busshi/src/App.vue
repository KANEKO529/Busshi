<template>
  <div id="app">
    <router-view />
  </div>
</template>

<script>

import Search from './components/Search.vue';
import Ranking from './components/Ranking.vue';
import Navigation from './components/Navigation.vue';
import Home from './components/Home.vue';

// モジュールとしてほかのファイルからインポートするため。このコンポーネント内で使用しなければ書かなくてよい。あくまでも読み込みたいとき。
export default {
  name: 'App',
  components: {
    Search,
    Ranking,
    Navigation,
    Home
  }
}

</script>
