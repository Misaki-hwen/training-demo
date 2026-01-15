<template>
  <div class="training-registration">
    <div class="card-header">
      <h2>培训报名</h2>
    </div>

    <el-row :gutter="20" style="margin-top: 20px;">
      <el-col :span="8" v-for="plan in plans" :key="plan.id">
        <el-card shadow="hover">
          <template #header>
            <div class="card-header">
              <span>{{ plan.name }}</span>
              <el-tag>{{ plan.position }}</el-tag>
            </div>
          </template>
          <div class="text item">
            <p><strong>企业名称:</strong> {{ plan.company }}</p>
            <p><strong>岗位信息:</strong> {{ plan.position }} · {{ plan.location }}</p>
            <p><strong>培训周期:</strong> {{ plan.period }}</p>
            <el-button type="primary" style="width: 100%; margin-top: 10px;" @click="handleRegister(plan)">立即报名</el-button>
          </div>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { ElMessage } from 'element-plus'

const plans = ref([
  { id: 101, name: 'Java 全栈开发特训营', position: 'Java 后端开发', company: '某知名互联网公司', period: '4个月', location: '北京·海淀' },
  { id: 102, name: '产品经理精英训练营', position: '产品经理', company: '某大型互联网企业', period: '1个月', location: '上海·浦东' },
  { id: 103, name: '数据科学入门班', position: '数据分析师', company: '未来数据科技公司', period: '1个月', location: '深圳·南山' },
])

const handleRegister = (plan) => {
  ElMessage.success(`Registered for ${plan.name}`)
}
</script>
