<template>
  <div class="training-config">
    <div class="card-header">
      <h2>Training Management</h2>
    </div>
    
    <el-form :model="form" label-width="150px" style="max-width: 600px; margin-top: 20px;">
      <el-form-item label="Default Duration">
        <el-input v-model="form.duration" placeholder="e.g. 3 Months" />
      </el-form-item>
      <el-form-item label="Passing Score">
        <el-input-number v-model="form.passingScore" :min="0" :max="100" />
      </el-form-item>
      <el-form-item label="Certificate Template">
        <el-select v-model="form.template" placeholder="Select Template">
          <el-option label="Standard" value="standard" />
          <el-option label="Premium" value="premium" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" @click="onSubmit">Save Configuration</el-button>
      </el-form-item>
    </el-form>
  </div>
</template>

<script setup>
import { reactive } from 'vue'
import { ElMessage } from 'element-plus'

const form = reactive({
  duration: '3 Months',
  passingScore: 60,
  template: 'standard',
})

const onSubmit = () => {
  ElMessage.success('Configuration Saved')
}
</script>
