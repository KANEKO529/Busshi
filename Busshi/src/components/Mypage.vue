<template>
    <div>
      <h1>マイページ</h1>
  
      <!-- プロフィール情報の表示 -->
      <div v-if="isAuthenticated">
        <p><strong>メールアドレス:</strong> {{ currentUser.email }}</p>
        <p><strong>性別:</strong> {{ user.gender }}</p>
        <p><strong>年齢:</strong> {{ user.age }}</p>
        <p><strong>住所:</strong> {{ user.prefecture }} {{ user.city }}</p>
      </div>
    </div>
  </template>
  