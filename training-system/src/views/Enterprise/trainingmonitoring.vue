<template>
  <div class="training-monitoring">
    <div class="card-header">
      <h2>培训考勤</h2>
    </div>

  <div class="filter-container" style="margin: 20px 0;">
      <el-select v-model="selectedCampName" placeholder="选择培训营" style="width: 240px; margin-right: 10px;">
        <el-option v-for="c in camps" :key="c.id" :label="c.name" :value="c.name" />
      </el-select>
  </div>

  <el-row :gutter="20">
      <el-col :span="6" v-for="item in stats" :key="item.label">
        <el-card shadow="hover">
          <template #header>
            <div class="card-header">
              <span>{{ item.label }}</span>
            </div>
          </template>
          <div style="font-size: 24px; font-weight: bold; text-align: center;">
            {{ item.value }}
          </div>
        </el-card>
      </el-col>
    </el-row>

    <h3 style="margin-top: 30px;">{{ selectedCampName ? ('培训营：' + selectedCampName + ' | 考勤明细') : 'Daily Attendance' }}</h3>
    <el-table :data="tableData" border style="width: 100%">
      <el-table-column prop="date" label="Date" width="150" />
      <el-table-column prop="present" label="Present" />
      <el-table-column prop="absent" label="Absent" />
      <el-table-column prop="leave" label="On Leave" />
      <el-table-column prop="rate" label="Attendance Rate">
        <template #default="scope">
           <el-progress :percentage="scope.row.rate" />
        </template>
      </el-table-column>
    </el-table>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'

const camps = ref([
  { id: 3, name: 'Java后端-一期(北大)', school: '北京大学', startDate: '2024-07-01', endDate: '2024-09-30' },
  { id: 1, name: '营销管培-一期(复旦)', school: '复旦大学', startDate: '2024-08-01', endDate: '2024-08-31' },
  { id: 2, name: '营销管培-二期(交大)', school: '上海交通大学', startDate: '2024-08-01', endDate: '2024-08-31' },
])
const selectedCampName = ref('')
const nowStr = new Date().toISOString().split('T')[0]
const pickLatestStartedCamp = () => {
  const started = camps.value.filter(c => c.startDate <= nowStr).sort((a, b) => b.startDate.localeCompare(a.startDate))
  if (started.length > 0) return started[0].name
  const upcoming = camps.value.slice().sort((a, b) => a.startDate.localeCompare(b.startDate))
  return upcoming.length ? upcoming[0].name : ''
}
selectedCampName.value = pickLatestStartedCamp()

const stats = ref([
  { label: 'Total Students', value: 45 },
  { label: 'Avg Attendance', value: '98%' },
  { label: 'Tasks Submitted', value: 120 },
  { label: 'Issues Reported', value: 2 },
])

const tableData = ref([
  { date: '2024-03-01', present: 44, absent: 0, leave: 1, rate: 98 },
  { date: '2024-03-02', present: 45, absent: 0, leave: 0, rate: 100 },
  { date: '2024-03-03', present: 43, absent: 1, leave: 1, rate: 95 },
])
</script>
