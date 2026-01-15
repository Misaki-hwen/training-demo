<template>
  <div class="student-app-shell">
    <div class="student-app-container">
      <div class="student-app-main">
        <TrainingRegistration v-if="activeTab === 'registration'" />
        <MyTraining v-else />
      </div>
      <div class="student-app-tabbar">
        <div
          class="student-app-tabbar-item"
          :class="{ active: activeTab === 'registration' }"
          @click="activeTab = 'registration'"
        >
          <div class="student-app-tabbar-text">报名</div>
        </div>
        <div
          class="student-app-tabbar-item"
          :class="{ active: activeTab === 'my-training' }"
          @click="activeTab = 'my-training'"
        >
          <div class="student-app-tabbar-text">我的</div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import TrainingRegistration from './TrainingRegistration.vue'
import MyTraining from './MyTraining.vue'

const activeTab = ref('registration')
</script>
