<template>
  <div class="student-management-op">
    <div class="card-header">
      <h3>学生管理 (运营)</h3>
    </div>
    <el-tabs type="card" v-model="activeSubTab">
      <el-tab-pane label="名单确认" name="confirmation">
        <div class="filter-container">
          <el-select placeholder="选择培训营" style="width: 200px;"></el-select>
          <el-button type="primary" @click="sendToEnterprise">发送名单给企业</el-button>
        </div>
        <el-table :data="finalList" border style="margin-top: 10px;">
          <el-table-column prop="name" label="姓名" width="100"></el-table-column>
          <el-table-column prop="camp" label="培训营"></el-table-column>
          <el-table-column prop="enterpriseStatus" label="企业筛选结果" width="120">
            <template #default="scope">
              <el-tag type="success">通过</el-tag>
            </template>
          </el-table-column>
          <el-table-column prop="studentConfirm" label="学生确认" width="120">
            <template #default="scope">
              <el-tag type="success">已确认</el-tag>
            </template>
          </el-table-column>
          <el-table-column prop="opStatus" label="运营确认" width="120">
            <template #default="scope">
              <el-tag :type="scope.row.opStatus === 'Confirmed' ? 'success' : 'warning'">{{ getOpConfirmStatusText(scope.row.opStatus) }}</el-tag>
            </template>
          </el-table-column>
          <el-table-column label="操作">
            <template #default="scope">
              <el-button size="small" type="primary" v-if="scope.row.opStatus !== 'Confirmed'" @click="confirmStudent(scope.row)">确认名单</el-button>
            </template>
          </el-table-column>
        </el-table>
      </el-tab-pane>

      <el-tab-pane label="培训考勤" name="attendance">
        <div class="filter-container">
          <el-select placeholder="选择培训营" style="width: 200px;"></el-select>
          <el-button type="primary">查询</el-button>
          <el-button type="success" plain>导出数据</el-button>
        </div>
        <el-table :data="attendanceData" border>
          <el-table-column prop="camp" label="培训营名称"></el-table-column>
          <el-table-column prop="totalStudents" label="总人数" width="100"></el-table-column>
          <el-table-column prop="avgRate" label="平均出勤率" width="120">
            <template #default="scope">
              <span style="color: green; font-weight: bold">{{ scope.row.avgRate }}</span>
            </template>
          </el-table-column>
          <el-table-column label="操作">
            <template #default="scope">
              <el-button size="small" link>查看明细</el-button>
            </template>
          </el-table-column>
        </el-table>
      </el-tab-pane>
    </el-tabs>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { ElMessage } from 'element-plus'

const activeSubTab = ref('confirmation')
const selectedRows = ref([])

const finalList = ref([
  { name: '张伟', camp: 'Java后端-一期', enterpriseStatus: 'Passed', studentConfirm: 'Confirmed', opStatus: 'Pending' },
  { name: '李娜', camp: '营销管培-三期', enterpriseStatus: 'Passed', studentConfirm: 'Confirmed', opStatus: 'Confirmed' },
  { name: '王强', camp: 'Java后端-一期', enterpriseStatus: 'Passed', studentConfirm: 'Confirmed', opStatus: 'Pending' },
  { name: '刘洋', camp: '营销管培-三期', enterpriseStatus: 'Passed', studentConfirm: 'Confirmed', opStatus: 'Confirmed' },
  { name: '陈静', camp: 'Java后端-一期', enterpriseStatus: 'Passed', studentConfirm: 'Confirmed', opStatus: 'Pending' },
  { name: '杨明', camp: '营销管培-三期', enterpriseStatus: 'Passed', studentConfirm: 'Confirmed', opStatus: 'Confirmed' },
  { name: '赵云', camp: 'Java后端-一期', enterpriseStatus: 'Passed', studentConfirm: 'Confirmed', opStatus: 'Pending' },
  { name: '孙悟空', camp: '营销管培-三期', enterpriseStatus: 'Passed', studentConfirm: 'Confirmed', opStatus: 'Confirmed' },
  { name: '猪八戒', camp: 'Java后端-一期', enterpriseStatus: 'Passed', studentConfirm: 'Confirmed', opStatus: 'Pending' },
  { name: '沙僧', camp: '营销管培-三期', enterpriseStatus: 'Passed', studentConfirm: 'Confirmed', opStatus: 'Confirmed' }
])

const attendanceData = ref([
  { camp: 'Java后端-一期', totalStudents: 45, avgRate: '98%' },
  { camp: '营销管培-三期', totalStudents: 30, avgRate: '95%' }
])

const getOpConfirmStatusText = (status) => ({ 'Confirmed': '已确认', 'Pending': '待确认' }[status] || status)

const handleSelectionChange = (val) => selectedRows.value = val

const confirmStudent = (row) => {
  row.opStatus = 'Confirmed'
  ElMessage.success('已确认名单')
}

const sendToEnterprise = () => {
  ElMessage.success('最终名单已发送给企业')
}
</script>

<style scoped>
.card-header {
  margin-bottom: 20px;
}
.filter-container {
  margin-bottom: 20px;
  display: flex;
  gap: 10px;
}
</style>
