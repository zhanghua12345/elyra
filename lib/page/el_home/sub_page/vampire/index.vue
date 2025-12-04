<template>
  <Nav :isLeft="true">{{ title || "Elyra TV" }}</Nav>
  <view class="flex flex-wrap justify-between px-32 mt-40">
    <view
      v-for="(item, index) in classifyList"
      :key="index"
      @click="goDetail(item)"
      :class="[
        'relative h-532 shadow-lg w-336 mb-14 rounded-[50rpx] overflow-hidden bg-[#5116C1] ',
      ]"
    >
      <image
        :src="item?.image_url"
        mode="aspectFill"
        class="w-full h-448 overflow-hidden rounded-[50rpx]"
      />
      <view class="px-74 mt-10 text-center leading-[32rpx] line-clamp-2">
        {{ item.name || "Elyra TV" }}
      </view>
    </view>
  </view>
</template>
<script setup>
import { onMounted, ref } from "vue";
import { onLoad } from "@dcloudio/uni-app";
import Nav from "../../components/nav";
import { getCategories } from "@/api/common.js";

import { onReachBottom } from "@dcloudio/uni-app";

const classifyList = ref([]);
const id = ref(0);
const title = ref("");

const params = ref({
  current_page: 0,
  page_size: 20,
  page_total: 0,
});
const isLoading = ref(false);
onLoad((options) => {
  title.value = options.title;
  id.value = options.id;
  getVideoList();
});

// 滚动到底部事件
onReachBottom(() => {
  console.log(params.value);
  if (!isLoading.value && params.value.current_page < params.value.page_total) {
    getVideoList();
  }
});

// 对应分类的视频数据
const getVideoList = async () => {
  isLoading.value = true;
  const res = await getCategories({
    ...params.value,
    category_id: id.value,
    current_page: params.value.current_page + 1,
  });
  classifyList.value =
    res.data.pagination.current_page === 1
      ? res.data.list
      : [...classifyList.value, ...res.data.list];

  params.value = res.data.pagination;
  isLoading.value = false;
};

const goDetail = (el) => {
  uni.navigateTo({
    url: `/pages/detail/index?id=${el.short_play_id}`,
  });
};
</script>
