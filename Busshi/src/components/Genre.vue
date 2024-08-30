<template>

    <div class="content-wrapper">
        <h2>ジャンル</h2>
    <div class="content-container">

    <div>
        <ul class="genre-list">
        <li v-for="(genre, index) in genres" :key="index">
            <button class="genre-button" @click="searchProducts">
            {{ genre.genreName }}
            </button>
        </li>
        </ul>
    </div>
</div>
</div>


</template>

<script>
import axios from 'axios';

export default {
data() {
  return {
    genres: []
  };
},
created() {
  this.fetchGenres();
},
    methods: {
async fetchGenres() {
try {
  const response = await axios.get('http://localhost:3000/genres'); // RailsのAPIエンドポイントにリクエスト
  console.log('ジャンルデータ:', response.data); // デバッグ用にデータの構造を確認

  if (response.data && Array.isArray(response.data)) {
    this.genres = response.data.map(item => item.child); 
  } else {
    console.error('Unexpected data format:', response.data);
  }
} catch (error) {
  console.error('ジャンル取得に失敗しました:', error.response || error.message);
}
}


}
}
</script>

<style>

.content-wrapper {
/* border-right: 1px solid #4d4d4d;  */
display: flex;
flex-direction: column;
align-items: center;
padding-top: 20px;

/* max-width: 80%; */
}

.genre-list {
list-style-type: none;
padding: 10px;
margin: 0;
border-right: 1px solid #000;
font-size: 13px;
}

.genre-list li {
padding: 10px;
border-bottom: 1px solid #ddd;
}

.content-container {
width: 100%;
max-width: 800px;
margin-bottom: 20px;
}

.genre-button {
width: 100%;
border: none; /* ボタンの枠線をなくす */
background-color: #ffffff; /* ボタンの背景色を白に設定 */
border-radius: 5px;
cursor: pointer;
text-align: left; /* ボタン内のテキストを左揃え */
outline: none; /* フォーカス時のアウトラインをなくす */
}

.genre-button:hover {
background-color: #f3f3f3; /* ホバー時の背景色を変更 */
}

</style>