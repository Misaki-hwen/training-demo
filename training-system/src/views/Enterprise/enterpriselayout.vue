<template>
  <div class="enterprise-layout">
    <el-card>
      <el-tabs v-model="activeTab">
        <el-tab-pane label="Plan Management" name="plan">
          <PlanManagement v-if="activeTab === 'plan'" />
        </el-tab-pane>
        <el-tab-pane label="Student Screening" name="screening">
          <StudentScreening v-if="activeTab === 'screening'" />
        </el-tab-pane>
        <el-tab-pane label="List Confirmation" name="confirmation">
          <ListConfirmation v-if="activeTab === 'confirmation'" />
        </el-tab-pane>
        <el-tab-pane label="Training Attendance" name="monitoring">
          <TrainingMonitoring v-if="activeTab === 'monitoring'" />
        </el-tab-pane>
        <el-tab-pane label="Assessment Results" name="results">
          <AssessmentResults v-if="activeTab === 'results'" />
        </el-tab-pane>
      </el-tabs>
    </el-card>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import PlanManagement from './PlanManagement.vue'
import StudentScreening from './StudentScreening.vue'
import ListConfirmation from './ListConfirmation.vue'
import TrainingMonitoring from './TrainingMonitoring.vue'
import AssessmentResults from './AssessmentResults.vue'

const activeTab = ref('plan')
</script>
