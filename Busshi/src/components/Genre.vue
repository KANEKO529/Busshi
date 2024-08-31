<template>
  <div class="content-wrapper">
    <h2>Genre</h2>
    <div class="content-container">
      <div>
        <ul class="genre-list">
          <li v-for="(genre, index) in predefinedGenres" :key="index" @mouseover="showSubGenres(index)" @mouseleave="hideSubGenres(index)">
            <button class="genre-button">
              {{ genre.name }}
            </button>
            <ul v-if="activeIndex === index" class="sub-genre-list">
              <li v-for="(subGenre, subIndex) in genre.subGenres" :key="subIndex">
                <button class="sub-genre-button" @click="navigateToSearch(subGenre)">
                  {{ subGenre.name }} <!-- サブジャンル名を表示 -->
                </button>
              </li>
            </ul>
          </li>
        </ul>
      </div>
    </div>
  </div>
</template>

<script>
import genres from '@/genres.js';

export default {
  props: ['predefinedGenres'],

  data() {


    return {
      predefinedGenres: genres,
      // [
      //   {
      //     name: "ファッション・インナー",
      //     subGenres: [
      //       { id: 100371, name: "レディースファッション", details: null },
      //       { id: 551177, name: "メンズファッション", details: null },
      //       { id: 100433, name: "インナー下着ナイトウェア", details: null }
      //     ]
      //   },
      //   {
      //     name: "ファッション小物",
      //     subGenres: [
      //       { id: 216131, name: "バッグ・小物・ブランド雑貨", details: null },
      //       { id: 558885, name: "靴", details: null },
      //       { id: 558929, name: "腕時計", details: null },
      //       { id: 216129, name: "ジュエリー", details: null }
      //     ]
      //   },
      //   {
      //     name: "食品・スイーツ",
      //     subGenres: [
      //       { id: 100227, name: "食品", details: null },
      //       { id: 551167, name: "スイーツ菓子", details: null }
      //     ]
      //   },
      //   // 他のトップレベルジャンルとサブジャンルも同様に追加
      // ],
      activeIndex: null,
    };
  },
  methods: {
    selectGenre(genreId) {
      this.$emit('genreSelected', genreId);
    },
    showSubGenres(index) {
      this.activeIndex = index;
    },
    hideSubGenres() {
      this.activeIndex = null;
    },
    navigateToSearch(subGenre) {
      this.$router.push({  name: 'home', query: { genreId: subGenre.id } });
    }
  }
};
</script>

<style>
.content-wrapper {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding-top: 6px;
}

.genre-list {
  list-style-type: none;
  padding: 10px;
  margin: 0;
  border-right: 1px solid #000;
  font-size: 10px;
}

.genre-list li {
  padding: 10px;
  border-bottom: 1px solid #ddd;
  position: relative;
}

.sub-genre-list {
  list-style-type: none;
  padding: 10px;
  margin: 0;
  background-color: #ffffff;
  border: 1px solid #ddd;
  position: absolute;
  top: 0;
  left: 100%;
  display: block;
  width: 800px;
}

.content-container {
  width: 100%;
  max-width: 800px;
  margin-bottom: 20px;
}

.genre-button, .sub-genre-button {
  width: 100%;
  border: none;
  background-color: #ffffff;
  border-radius: 5px;
  cursor: pointer;
  text-align: left;
  outline: none;
}

.genre-button:hover, .sub-genre-button:hover {
  background-color: #f3f3f3;
  /* width: 50px; */
}
</style>
