<template>
    <div>
      <div>
        <label>Gender:</label>
        <select v-model="filters.gender">
          <option value="">All</option>
          <option value="male">Male</option>
          <option value="female">Female</option>
          <!-- 他のオプションを追加 -->
        </select>
        
        <!-- <label>Age Group:</label>
        <select v-model="filters.age_group">
            <option value="">All</option>
            <option value="teens">10代</option>
            <option value="twenties">20代</option>
            <option value="thirties">30代</option>
            <option value="forties">40代</option>
            <option value="fifties">50代</option>
            <option value="sixties">60代</option>
        </select>

        <label>Prefecture:</label>
        <input type="text" v-model="filters.prefecture" placeholder="Prefecture">
        
        <label>City:</label>
        <input type="text" v-model="filters.city" placeholder="City"> -->
      </div>
  
      <button @click="getRankings">Get Rankings</button>
  
      <!-- <div>
                <ul>
      <li v-for="(ranking, index) in rankings" :key="ranking.item_code">
        <h3>{{ index + 1 }}位: {{ ranking.product_name }}</h3>
        <img :src="ranking.image_url" alt="Product Image" />
        <p>Price: {{ ranking.price }}</p>
        <p>Review Score: {{ ranking.review_score }}</p>
        <p>Desire Level: {{ ranking.total_desire }}</p>
        <p>Votes: {{ ranking.vote_count }}</p>
        <a :href="ranking.item_url" target="_blank">View Product</a>
      </li>
    </ul>
      </div>
 -->

    </div>
  </template>
  
  <script>
  export default {
    data() {
      return {
        filters: {
          gender: '',
          age_group: '',
          prefecture: '',
          city: ''
        },
        rankings: []
      };
    },
    methods: {
    getRankings() {
      const params = new URLSearchParams(this.filters).toString();

      console.log(params)
      fetch(`/rankings?${params}`)
        .then(response => {

        console.log(response)
          if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
          }

        //   console.log(response.json())
          return response.json();
        })
        .then(data => {
          this.rankings = data;
        })
        .catch(error => {
          console.error("Failed to fetch rankings:", error);
          alert(`Failed to fetch rankings: ${error.message}`);
        });
    }
  },
  mounted() {
    this.getRankings();
  }
}
  </script>
  