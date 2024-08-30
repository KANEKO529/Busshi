<template>
    <Navigation />
    <div class="container">
        <div class="component3">
            <Genre />
        </div>

        <div class="component1">
            <Search />
        </div>
        <div class="component2">
            <Ranking />
        </div>


    </div>

</template>

<script>

import Ranking from './Ranking.vue';
import Search from './Search.vue';
import Navigation from './Navigation.vue';
import Genre from './Genre.vue';

export default {
  name: 'App',
  components: {
    Search,
    Ranking,
    Navigation,
    Genre
  }
}

</script>

<style scoped>

.container {
    display: flex;
    width: 100%;
    /* justify-content: space-between; コンポーネント間に均等なスペースを配置する */
}

.component1 {
   width: 60%;
}
.component2 {
    width: 30%;
}

.component3 {
    width: 10%;
}

</style>
