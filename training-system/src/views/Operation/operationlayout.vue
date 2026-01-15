<template>
  <div class="operation-layout">
    <el-card>
      <el-tabs v-model="activeTab">
        <el-tab-pane label="Plan Audit" name="audit">
          <PlanAudit v-if="activeTab === 'audit'" />
        </el-tab-pane>
        <el-tab-pane label="Training Management" name="config">
          <TrainingConfig v-if="activeTab === 'config'" />
        </el-tab-pane>
        <el-tab-pane label="Student Management" name="student">
          <StudentManagement v-if="activeTab === 'student'" />
        </el-tab-pane>
        <el-tab-pane label="Settlement Management" name="settlement">
          <SettlementManagement v-if="activeTab === 'settlement'" />
        </el-tab-pane>
      </el-tabs>
    </el-card>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import PlanAudit from './PlanAudit.vue'
import TrainingConfig from './TrainingConfig.vue'
import StudentManagement from './StudentManagement.vue'
import SettlementManagement from './SettlementManagement.vue'

const activeTab = ref('audit')
</script>
