
enum FILTER_STATUS { All_TASK}

class Filter {
  FILTER_STATUS filterStatus;

  Filter.byAllTask() {
    filterStatus = FILTER_STATUS.All_TASK;
  }
}