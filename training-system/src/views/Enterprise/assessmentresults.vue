<template>
  <div class="assessment-results">
    <div class="card-header">
      <h2>考核结果</h2>
    </div>
    
    <div class="filter-container" style="margin: 20px 0; display: flex; gap: 10px; align-items: center;">
      <el-select v-model="selectedCampName" placeholder="选择培训营" style="width: 240px;">
        <el-option v-for="c in camps" :key="c.id" :label="c.name" :value="c.name" />
      </el-select>
      <el-button type="primary" @click="handleQuery">查询</el-button>
    </div>
    
    <div id="chart" style="width: 100%; height: 300px; margin-bottom: 20px;"></div>

    <div style="margin-top: 20px;">
        <h3>{{ selectedCampName ? ('培训营：' + selectedCampName + ' | 成绩明细') : 'Detailed Scores' }}</h3>
        <el-table :data="tableData" border style="width: 100%">
            <el-table-column prop="name" label="姓名" />
            <el-table-column prop="score" label="成绩" sortable />
            <el-table-column prop="grade" label="等级" />
        </el-table>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, watch } from 'vue'
import * as echarts from 'echarts'

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

const tableMap = {
  'Java后端-一期(北大)': [
    { name: '张伟', score: 95, grade: 'A' },
    { name: '李娜', score: 88, grade: 'B' },
    { name: '王强', score: 72, grade: 'C' },
  ],
  '营销管培-一期(复旦)': [
    { name: '赵敏', score: 85, grade: 'B' },
    { name: '钱坤', score: 73, grade: 'C' },
    { name: '孙杰', score: 59, grade: 'D' },
  ],
  '营销管培-二期(交大)': [
    { name: '李四', score: 91, grade: 'A' },
    { name: '王五', score: 77, grade: 'B' },
    { name: '郑十', score: 66, grade: 'C' },
  ],
}

const tableData = ref(tableMap[selectedCampName.value] || [])
let myChart

onMounted(() => {
  const chartDom = document.getElementById('chart')
  myChart = echarts.init(chartDom)
  const option = {
    title: { text: selectedCampName.value + ' 成绩分布' },
    tooltip: {},
    xAxis: { data: ['A', 'B', 'C', 'D', 'F'] },
    yAxis: {},
    series: [
      {
        name: 'Students',
        type: 'bar',
        data: [15, 20, 10, 5, 2]
      }
    ]
  }
  myChart.setOption(option)
})

watch(selectedCampName, (val) => {
  tableData.value = tableMap[val] || []
  if (myChart) {
    myChart.setOption({
      title: { text: val + ' 成绩分布' }
    })
  }
})
</script>
