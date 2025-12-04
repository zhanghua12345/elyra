<template>
  <image
    class="w-full fixed top-0 left-0 right-0 z-1b"
    src="/static/bg.png"
    mode="widthFix"
  />
  <view
    class="fixed top-0 left-0 w-full z-full overflow-hidden bg-000"
    :style="{
      height: `${systemInfo?.statusBarRpx + 214}rpx`,
    }"
  >
    <image class="w-full" src="/static/bg.png" mode="widthFix" />
    <view
      class="absolute left-0 w-full h-88 overflow-auto flex flex-row items-center justify-between px-32"
      :style="{
        top: `${systemInfo?.statusBarRpx}rpx`,
      }"
    >
      <image src="/src/static/home/logo.png" class="w-244" mode="widthFix" />
      <image
        src="/src/static/home/search.png"
        mode="widthFix"
        class="w-60"
        @click="goSearch"
      />
    </view>
    <view
      class="w-full flex flex-col items-center absolute left-0"
      :style="{
        top: `${systemInfo?.statusBarRpx + 108}rpx`,
      }"
    >
      <view
        class="border-gradient w-686 h-86 rounded-full flex items-center justify-center relative gap-26"
      >
        <view
          v-for="(item, index) in tab"
          @click="tabClick(index)"
          :key="index"
          :class="[
            ' text-28 font-900 px-20 py-12 leading-[34rpx] rounded-full',
            index === tabIdx
              ? 'bg-[linear-gradient(0deg,_#E424AE_0%,_#6018E6_100%)] text-fff shadow-home-tabs'
              : 'text-fff-8',
          ]"
        >
          {{ item }}
        </view>
      </view>
    </view>
  </view>
  <view
    class="w-full flex flex-col items-center pb-60"
    :style="{
      paddingTop: `${systemInfo?.statusBarRpx + 214}rpx`,
    }"
  >
    <z-paging
      @query="queryList"
      :refresher-only="true"
      ref="paging"
      :auto="false"
      :style="{
        paddingTop: `${systemInfo?.statusBarRpx + 214}rpx`,
      }"
    >
      <template #refresher="{ refresherStatus }">
        <view class="text-24 text-center">{{
          getRefresherStatusName(refresherStatus)
        }}</view>
      </template>
      <view class="w-full mt-20" v-show="tabIdx === 2">
        <view
          class="h-384 mb-36 mx-24 py-12 relative bg-[url('/static/home/vampire.png')] bg-full flex flex-col items-center justify-between"
          v-for="(item, index) in categoryList"
          :key="index"
        >
          <view class="font-600 text-32 leading-[40rpx]">
            {{ item?.category_name || "Elyra TV" }}
          </view>
          <view class="w-full flex justify-between px-56">
            <image
              v-for="e in item?.short_play_list || ['', '', '']"
              @click="goDetail(e)"
              :key="e.id"
              :src="e?.image_url || '/static/none-3.png'"
              mode="aspectFill"
              class="w-168 h-224 rounded-[30rpx]"
            />
          </view>
          <view
            class="font-600 text-32 leading-[40rpx]"
            @click="goClassify(item)"
            >More</view
          >
        </view>
      </view>
      <view class="w-full mt-20" v-show="tabIdx === 3">
        <view class="flex flex-wrap justify-between mx-32 relative pb-20">
          <image
            src="/static/home/releases.png"
            mode="aspectFit"
            class="w-686 h-532 absolute z-1b"
          />
          <view class="w-336 h-0"></view>
          <view
            class="w-336 h-138 mb-14 flex justify-center items-center text-36 font-600"
          >
            New Releases
          </view>
          <view
            v-for="(item, index) in newList"
            :key="item.id"
            @click="goDetail(item)"
            :class="[
              'relative h-532 shadow-lg w-336 mb-14 rounded-[50rpx] overflow-hidden',
              index % 2 === 0 ? 'mt-[-152rpx]' : 'mt-0',
              index === 0 ? '' : 'bg-[#5116C1] ',
            ]"
          >
            <image
              :src="item?.image_url || '/static/none-3.png'"
              mode="aspectFill"
              class="w-full h-448 overflow-hidden rounded-[50rpx]"
            />
            <view class="px-74 mt-10 text-center leading-[32rpx] line-clamp-2">
              {{ item?.name || "Elyra TV " }}
            </view>
          </view>
        </view>
      </view>
    </z-paging>
  </view>
</template>
<script setup>
import { useAppStore } from "@/store/app";
import { onMounted, ref } from "vue";
import {
  getHomeData,
  getRankingData,
  getCategoryListAppendShortPlay,
} from "@/api/common";
import { numberFilter } from "@/utils";

const REFRESHERSTATUSNAME = {
  default: "Pull down to refresh",
  "release-to-refresh": "Release to refresh",
  loading: "Refreshing...",
  complete: "Refresh complete",
};

const getRefresherStatusName = (val) => {
  return REFRESHERSTATUSNAME[val];
};

const tab = ref(["Popular", "Rankings", "Genres", "New"]);
const tabIdx = ref(0);
const current = ref(0);
const systemInfo = ref(null);
const paging = ref(null);
const date = ref({
  home_banner: ["", "", "", "", ""],
  week_ranking: ["", "", "", "", ""],
  new_recommand: { list: ["", "", "", "", ""] },
  highest_payment_hot_video: ["", "", "", "", ""],
});
const rankingList = ref(["", "", "", "", "", "", "", "", "", ""]);
const categoryList = ref(["", "", "", ""]);
const newList = ref(["", "", "", "", ""]);

// 下拉触发
const queryList = () => {
  switch (tabIdx.value) {
    case 0:
      date.value = {
        home_banner: ["", "", "", "", ""],
        week_ranking: ["", "", "", "", ""],
        new_recommand: { list: ["", "", "", "", ""] },
        highest_payment_hot_video: ["", "", "", "", ""],
      };
      setTimeout(() => {
        homeData();
        paging.value.complete();
      }, 500);
      break;
    case 1:
      rankingList.value = ["", "", "", "", "", "", "", "", "", ""];
      setTimeout(() => {
        rankingData();
        paging.value.complete();
      }, 500);

      break;
    case 2:
      categoryList.value = ["", "", "", ""];
      setTimeout(() => {
        categoryListAppendShortPlayList();
        paging.value.complete();
      }, 500);
      break;
    case 3:
      newList.value = ["", "", "", "", ""];
      setTimeout(() => {
        newData();
        paging.value.complete();
      }, 500);
      break;
    default:
      break;
  }
};

const onChange = (e) => {
  current.value = e.detail.current;
};

// 页面加载时自动加载数据
onMounted(() => {
  const appStore = useAppStore();
  systemInfo.value = appStore.systemInfo?.windowHeight
    ? appStore.systemInfo
    : appStore.getSystemInfo();

  homeData();
  setTimeout(() => {
    rankingData();
    newData();
    categoryListAppendShortPlayList();
  }, 1000);
});

const tabClick = (index) => {
  tabIdx.value = index;
  paging.value.scrollToTop();
};
// 首页数据
const homeData = async () => {
  const res = await getHomeData();
  res.data.list.forEach((el) => {
    date.value[el.module_key] = el.data;
  });
};
// 首页排行
const rankingData = async () => {
  const res = await getRankingData({ type: "most_trending" });
  if (res?.data?.list.length) {
    const arr = res?.data?.list;
    rankingList.value = [...arr];
    rankingList.value[0] = arr[1];
    rankingList.value[1] = arr[0];
  } else {
    rankingList.value = [];
  }
};
// 首页分类
const categoryListAppendShortPlayList = async () => {
  const res = await getCategoryListAppendShortPlay({ num: 3 });
  categoryList.value = res?.data?.list || [];
};
// 首页最新
const newData = async () => {
  const res = await getRankingData({ type: "new_releases" });
  newList.value = res?.data?.list || [];
};

const goClassify = (item) => {
  uni.navigateTo({
    url: `/pages/classify/index?id=${item.id}&title=${item.category_name}`,
  });
};

const goDetail = (el) => {
  uni.navigateTo({
    url: `/pages/elplay/index?id=${el.short_play_id}`,
  });
};
const goSearch = (el) => {
  uni.navigateTo({
    url: `/pages/search/index`,
  });
};
</script>
