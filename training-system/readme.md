# Multi-Role Training Management System Prototype

This is a Vue 3 + Element Plus based prototype for a training management system.

## Project Structure

- **src/views/Enterprise**: Enterprise role pages (Plan Management, Student Screening, etc.)
- **src/views/Operation**: Operation role pages (Plan Audit, Config, etc.)
- **src/views/School**: School role pages (Training Management, Attendance)
- **src/views/Student**: Student role pages (Registration, My Training)
- **src/router**: Route configuration for top-level role switching.

## Features

- **Top Navigation**: Switch between 4 major roles.
- **Sub-navigation**: Tab-based navigation within each role.
- **Plan Management**: Create/Edit plans with validation and complex inputs.
- **Charts**: ECharts integration for assessment results.
- **Mock Data**: Static JSON data used for all tables and lists.

## Setup & Run

1.  Install dependencies:
    ```bash
    npm install
    ```

2.  Run development server:
    ```bash
    npm run dev
    ```

3.  Build for production:
    ```bash
    npm run build
    ```
