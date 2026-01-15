<template>
  <div class="my-training">
    <div class="card-header">
      <h3>我的培训</h3>
    </div>

    <el-tabs v-model="activeSubTab" type="card">
      <!-- 1. 报名状态页 -->
      <el-tab-pane label="报名状态" name="status">
        <el-table :data="myPlans" border stripe style="width: 100%">
          <el-table-column prop="name" label="培训名称" min-width="180" />
          <el-table-column prop="company" label="企业名称" min-width="180" />
          <el-table-column prop="applyTime" label="报名时间" width="180" />
          <el-table-column prop="status" label="审核状态" width="120">
            <template #default="scope">
              <el-tag :type="getStatusType(scope.row.status)">
                {{ getStatusLabel(scope.row.status) }}
              </el-tag>
            </template>
          </el-table-column>
          <el-table-column label="操作" width="150" fixed="right">
            <template #default="scope">
              <el-button 
                size="small" 
                type="primary" 
                v-if="scope.row.status === 'Passed'" 
                @click="viewSchedule(scope.row)"
              >
                查看安排
              </el-button>
            </template>
          </el-table-column>
        </el-table>
      </el-tab-pane>

      <!-- 2. 培训安排页 -->
      <el-tab-pane label="培训安排" name="schedule">
        <div v-if="currentTraining" class="schedule-container">
          <div class="training-info-bar">
            <span class="training-title">{{ currentTraining.name }} - 课程表</span>
            <div class="actions">
              <el-button type="primary" link @click="activeSubTab = 'checkin'">去签到 >></el-button>
            </div>
          </div>
          
          <el-table :data="scheduleList" border style="width: 100%">
            <el-table-column prop="date" label="日期" width="120" />
            <el-table-column prop="time" label="时间" width="150" />
            <el-table-column prop="location" label="地点" width="180" />
            <el-table-column prop="topic" label="主题" min-width="200" />
            <el-table-column prop="attendance" label="出勤状态" width="120">
              <template #default="scope">
                <el-tag :type="getAttendanceType(scope.row.attendance)">
                  {{ getAttendanceLabel(scope.row.attendance) }}
                </el-tag>
              </template>
            </el-table-column>
          </el-table>
        </div>
        <el-empty v-else description="请先在“报名状态”页选择一个已通过的培训" />
      </el-tab-pane>

      <!-- 3. 签到入口页 -->
      <el-tab-pane label="签到打卡" name="checkin">
        <div v-if="currentTraining" class="checkin-container">
          <div class="checkin-card">
            <h4>{{ currentTraining.name }}</h4>
            <div class="qr-section">
              <p class="label">我的签到码</p>
              <div class="qr-placeholder">
                <el-icon :size="100" color="#909399"><Picture /></el-icon>
                <p>向老师出示此码</p>
              </div>
            </div>
            <div class="divider">或者</div>
            <div class="scan-section">
              <el-button type="primary" size="large" icon="FullScreen" @click="handleScan">
                扫码签到
              </el-button>
              <p class="hint">扫描教室屏幕上的二维码</p>
            </div>
          </div>
        </div>
        <el-empty v-else description="请先选择一个培训项目" />
      </el-tab-pane>
    </el-tabs>

    <!-- 扫码模拟弹窗 -->
    <el-dialog v-model="scanVisible" title="扫码签到" width="300px" center append-to-body>
      <div style="text-align: center;">
        <div class="camera-mock">
          [ 摄像头预览区域 ]
        </div>
        <p style="margin-top: 10px; color: #666;">请将摄像头对准签到二维码</p>
      </div>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="scanVisible = false">取消</el-button>
          <el-button type="success" @click="confirmScan">模拟扫码成功</el-button>
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { ElMessage } from 'element-plus'
import { FullScreen, Picture } from '@element-plus/icons-vue'

const activeSubTab = ref('status')
const scanVisible = ref(false)
const currentTraining = ref(null)

// Mock Data
const myPlans = ref([
  { 
    id: 101, 
    name: 'Java 全栈开发特训营', 
    company: 'Tech Giant Corp', 
    applyTime: '2024-02-20 14:30', 
    status: 'Passed' 
  },
  { 
    id: 102, 
    name: '产品经理精英训练营', 
    company: 'Tech Giant Corp', 
    applyTime: '2024-03-05 09:15', 
    status: 'Pending' 
  }
])

const scheduleList = ref([
  { date: '2024-07-05', time: '14:00-16:00', location: '第三教学楼 301', topic: 'Java 并发编程实战', attendance: 'Present' },
  { date: '2024-07-06', time: '09:00-11:00', location: '第三教学楼 301', topic: '分布式架构设计', attendance: 'Absent' },
  { date: '2024-07-07', time: '14:00-16:00', location: '第三教学楼 302', topic: '微服务实战', attendance: 'Pending' },
  { date: '2024-07-08', time: '09:00-11:00', location: '第三教学楼 302', topic: '容器化部署 (Docker & K8s)', attendance: 'Pending' }
])

// Helpers
const getStatusLabel = (status) => {
  const map = { 'Pending': '待审核', 'Passed': '已通过', 'Rejected': '未通过' }
  return map[status] || status
}

const getStatusType = (status) => {
  const map = { 'Pending': 'warning', 'Passed': 'success', 'Rejected': 'danger' }
  return map[status] || 'info'
}

const getAttendanceLabel = (status) => {
  const map = { 'Present': '已参加', 'Absent': '缺勤', 'Pending': '待签到' }
  return map[status] || status
}

const getAttendanceType = (status) => {
  const map = { 'Present': 'success', 'Absent': 'danger', 'Pending': 'info' }
  return map[status] || ''
}

// Actions
const viewSchedule = (row) => {
  currentTraining.value = row
  activeSubTab.value = 'schedule'
}

const handleScan = () => {
  scanVisible.value = true
}

const confirmScan = () => {
  scanVisible.value = false
  ElMessage.success('签到成功！')
  // Update the first pending schedule to Present for demo
  const idx = scheduleList.value.findIndex(s => s.attendance === 'Pending')
  if (idx !== -1) {
    scheduleList.value[idx].attendance = 'Present'
  }
}
</script>

<style scoped>
.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.training-info-bar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  background-color: #f5f7fa;
  padding: 15px;
  border-radius: 4px;
  margin-bottom: 20px;
}

.training-title {
  font-size: 16px;
  font-weight: bold;
  color: #303133;
}

.checkin-container {
  display: flex;
  justify-content: center;
  padding: 40px 0;
}

.checkin-card {
  width: 360px;
  background: #fff;
  border: 1px solid #ebeef5;
  border-radius: 8px;
  padding: 30px;
  text-align: center;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
}

.qr-section {
  margin-bottom: 20px;
}

.qr-placeholder {
  width: 180px;
  height: 180px;
  background-color: #f2f6fc;
  margin: 15px auto;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  color: #909399;
  font-size: 12px;
}

.divider {
  margin: 20px 0;
  color: #909399;
  font-size: 14px;
  position: relative;
}

.divider::before, .divider::after {
  content: '';
  position: absolute;
  top: 50%;
  width: 40%;
  height: 1px;
  background: #ebeef5;
}

.divider::before { left: 0; }
.divider::after { right: 0; }

.camera-mock {
  width: 200px;
  height: 200px;
  background: #000;
  color: #fff;
  display: flex;
  align-items: center;
  justify-content: center;
  margin: 0 auto;
}

.hint {
  font-size: 12px;
  color: #909399;
  margin-top: 8px;
}
</style>
