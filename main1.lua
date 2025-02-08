require "vinx.core.Import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "Gh"
import "androidx.appcompat.widget.LinearLayoutCompat"
local json = require "cjson"

-- 归鸿
local CoordinatorLayout = luajava.bindClass "androidx.coordinatorlayout.widget.CoordinatorLayout"
local AppBarLayout = luajava.bindClass "com.google.android.material.appbar.AppBarLayout"
local CollapsingToolbarLayout = luajava.bindClass "com.google.android.material.appbar.CollapsingToolbarLayout"
local NestedScrollView = luajava.bindClass "androidx.core.widget.NestedScrollView"
local MaterialToolbar = luajava.bindClass "com.google.android.material.appbar.MaterialToolbar"
local MaterialTextView = luajava.bindClass "com.google.android.material.textview.MaterialTextView"
local MaterialCardView = luajava.bindClass "com.google.android.material.card.MaterialCardView"
local TextInputEditText = luajava.bindClass "com.google.android.material.textfield.TextInputEditText"
local ImageFilterView = luajava.bindClass "androidx.constraintlayout.utils.widget.ImageFilterView"
local RecyclerView = luajava.bindClass "androidx.recyclerview.widget.RecyclerView"
local LuaRecyclerAdapter = require "LuaRecyclerAdapter"
local StaggeredGridLayoutManager = luajava.bindClass "androidx.recyclerview.widget.StaggeredGridLayoutManager"
import "androidx.recyclerview.widget.LinearLayoutManager"
import "github.znzsofficial.adapter.LuaCustRecyclerAdapter"
import "com.lua.custrecycleradapter.LuaCustRecyclerAdapter"
import "androidx.recyclerview.widget.GridLayoutManager"
local LuaCustRecyclerAdapter = luajava.bindClass "com.lua.custrecycleradapter.LuaCustRecyclerAdapter"
local LuaCustRecyclerHolder = luajava.bindClass "com.lua.custrecycleradapter.LuaCustRecyclerHolder"
local AdapterCreator = luajava.bindClass "com.lua.custrecycleradapter.AdapterCreator"

local modelParams = {
  model = "deepseek-ai/DeepSeek-V3",
  max_tokens = 512,
  temperature = 0.7,
  top_p = 0.7,
  top_k = 50,
  frequency_penalty = 0.5,
}

layout = {
  LinearLayoutCompat,
  layout_width = 'fill',
  layout_height = 'fill',
  orientation = "vertical",
  {
    LinearLayoutCompat,
    layout_width = "fill",
    layout_height = "100dp",
    BackgroundColor = "#EEEFF4",
    {
      MaterialTextView,
      layout_marginTop = 状态栏高度(),
      layout_gravity = "left|center",
      text = "异能AI",
      textSize = "24dp",
      layout_margin = "15dp",
      textColor = "0xff000000",
    },
  },
  {
    RecyclerView,
    layout_width = "fill",
    layout_height = "fill",
    id = "recy",
    layout_weight = "1",
  },
  {
    LinearLayoutCompat,
    layout_width = "fill",
    layout_height = "wrap",
    orientation = "vertical",
    {
      LinearLayoutCompat,
      layout_width = "fill",
      layout_height = "wrap",
      layout_margin = "10dp",
      {
        MaterialCardView,
        layout_gravity = "center",
        radius = "30dp",
        {
          MaterialTextView,
          layout_marginTop = "5dp",
          layout_marginLeft = "10dp",
          text = "深度思考",
          layout_marginRight = "10dp",
          layout_marginBottom = "5dp",
        },
      },
      {
        MaterialCardView,
        layout_gravity = "center",
        radius = "30dp",
        layout_marginLeft = "10dp",
        {
          MaterialTextView,
          layout_marginTop = "5dp",
          layout_marginLeft = "10dp",
          text = "模型设置",
          layout_marginRight = "10dp",
          layout_marginBottom = "5dp",
          id = "modelSettings"
        },
      },
      {
        MaterialTextView,
        layout_weight = "1",
      },
      {
        CircleImageView,
        layout_gravity = "center",
        layout_height = "20dp",
        layout_width = "20dp",
      },
    },
    {
      LinearLayoutCompat,
      layout_width = "fill",
      layout_height = "wrap",
      {
        LinearLayoutCompat,
        layout_width = "fill",
        layout_height = "wrap",
        layout_weight = "1",
        {
          MaterialCardView,
          layout_marginLeft = "10dp",
          radius = "30dp",
          layout_gravity = "center",
          layout_height = "wrap_content",
          layout_width = "match_parent",
          {
            TextInputEditText,
            layout_marginLeft = "10dp",
            backgroundColor = "0000",
            hint = "请输入内容",
            gravity = "left|top",
            layout_height = "fill",
            layout_marginRight = "10dp",
            textSize = "14sp",
            layout_width = "match_parent",
            id = "编辑框",
          },
        },
      },
      {
        ImageView,
        layout_marginLeft = "10dp",
        layout_width = "30dp",
        layout_height = "30dp",
        layout_marginRight = "10dp",
        layout_gravity = "center",
        id = "发送",
      },
    },
  },
}

activity
.setTheme(R.style.Theme_Material3_Blue)
.setTitle("异能AI")
.setContentView(loadlayout(layout))
activity.getSupportActionBar().hide()
if Build.VERSION.SDK_INT >= 19 then
  activity.getWindow().addFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS)
end
activity.getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_ADJUST_PAN)
全局字体()

me = {
  LinearLayoutCompat,
  layout_height = "wrap",
  layout_width = "fill",
  padding = "10dp",
  gravity = "right",
  {
    MaterialCardView,
    radius = "30dp",
    layout_width = "wrap",
    layout_height = "wrap",
    layout_marginRight = "10dp",
    {
      MaterialTextView,
      layout_marginTop = "5dp",
      layout_marginBottom = "5dp",
      layout_marginRight = "10dp",
      layout_marginLeft = "10dp",
      textSize = "15sp",
      layout_height = "wrap_content",
      layout_width = "match_parent",
      id = "内容",
      Typeface = 字体1(),
      textIsSelectable = true,
    },
  },
  {
    MaterialCardView,
    radius = "360",
    layout_width = "35dp",
    layout_height = "35dp",
    {
      ImageFilterView,
      layout_gravity = "center",
      layout_width = "25dp",
      layout_height = "25dp",
      id = "头像",
      round = "360",
    },
  },
}

ta = {
  LinearLayoutCompat,
  layout_height = "wrap",
  layout_width = "fill",
  padding = "10dp",
  {
    MaterialCardView,
    radius = "360",
    layout_width = "35dp",
    layout_height = "35dp",
    {
      ImageFilterView,
      layout_gravity = "center",
      layout_width = "25dp",
      layout_height = "25dp",
      id = "头像",
      round = "360",
    },
  },
  {
    LinearLayoutCompat,
    orientation = "vertical",
    layout_height = "wrap_content",
    layout_width = "fill",
    layout_marginLeft = "10dp",
    {
      MaterialTextView,
      textSize = "15sp",
      layout_height = "wrap_content",
      layout_width = "match_parent",
      id = "内容",
      Typeface = 字体1(),
      textIsSelectable = true,
    },
    {
      LinearLayoutCompat,
      layout_marginTop = "10dp",
      layout_height = "wrap_content",
      layout_width = "wrap",
      {
        ImageView,
        layout_height = "20dp",
        layout_width = "20dp",
        src = "png/1.png",
        id = "复制",
      },
      {
        ImageView,
        layout_marginLeft = "10dp",
        layout_height = "20dp",
        layout_width = "20dp",
        src = "png/2.png",
      },
    },
  },
}

jiazai = {
  LinearLayoutCompat,
  layout_height = "wrap",
  layout_width = "fill",
  padding = "10dp",
  {
    MaterialCardView,
    radius = "360",
    layout_width = "35dp",
    layout_height = "35dp",
    {
      ImageFilterView,
      layout_gravity = "center",
      layout_width = "25dp",
      layout_height = "25dp",
      id = "头像",
      round = "360",
    },
  },
  {
    ImageView,
    layout_height = "40dp",
    layout_width = "200dp",
    id = "加载",
  },
}

data = {}

-- 初始数据
数据 = {
  {Who = "ta", 内容 = "你好\n欢迎您使用异能AI\n您可以问我:今天天气怎么样或其他想问的问题", 头像 = "png/ta/deepseek.png"},
}
首次对话 = true

function 写入信息(a, b)
  table.clear(data)
  table.insert(a, b)
  刷新数据()
end

function 删除信息(a, b)
  table.remove(a, b)
  刷新数据()
end

adp = LuaCustRecyclerAdapter(AdapterCreator({
  getItemCount = function()
    return #data
  end,
  getItemViewType = function(position)
    if 数据[position + 1].Who == "me" then
      return 0
     elseif 数据[position + 1].Who == "ta" then
      return 1
     elseif 数据[position + 1].Who == "jiazai" then
      return 2
    end
  end,
  onCreateViewHolder = function(parent, viewType)
    local views = {}
    local layout
    if viewType == 0 then
      layout = loadlayout(me, views)
     elseif viewType == 1 then
      layout = loadlayout(ta, views)
     elseif viewType == 2 then
      layout = loadlayout(jiazai, views)
    end
    local holder = LuaCustRecyclerHolder(layout)
    holder.view.setTag(views)
    return holder
  end,
  onBindViewHolder = function(holder, position)
    local view = holder.view.getTag()
    local data = 数据[position + 1]
    view.头像.setImageBitmap(loadbitmap(activity.getLuaDir() .. "/" .. data.头像))
    if data.Who == "jiazai" then
      view.加载.setImageDrawable(LottieDrawable("加载", 0xff000000).loop(true).playAnimation())
     elseif data.Who == "me" then
      view.内容.setText(data.内容)
     elseif data.Who == "ta" then
      if position + 1 == 记录数值 then
        function fun(str, b)
          view.内容.setText(str)
        end
        thread(function(内容)
          require "import"
          local len = string.len(内容)
          for i = 1, len do
            Thread.sleep(30)
            call("fun", string.sub(内容, 1, i), i)
          end
          collectgarbage("collect")
        end, data.内容)
       else
        view.内容.setText(data.内容)
      end
      view.复制.onClick = function(v)
        水珠动画(v, 200)
        写入剪切板(data.内容)
        QQ提示("已复制内容")
      end
     else
    end
  end,
}))

recy.setAdapter(adp).setLayoutManager(StaggeredGridLayoutManager(1, 1))

function 刷新数据()
  记录数值 = 0
  for k, v in pairs(数据) do
    table.insert(data, 数据[k])
    记录数值 = 记录数值 + 1
  end
  adp.notifyDataSetChanged()
end

刷新数据()

lottieDrawable = LottieDrawable("向上", 0xff000000)
lottieDrawable.loop(false)
lottieDrawable.setMinFrame(60)
lottieDrawable.setMaxFrame(60)
lottieDrawable.playAnimation()
发送.setImageDrawable(lottieDrawable)

发送.onClick = function()
  if 编辑框.text == "" then
    QQ提示("输入内容不得为空")
   else
    写入信息(数据, {Who = "me", 内容 = 编辑框.text, 头像 = "png/me/7h.png"})
    写入信息(数据, {Who = "jiazai", 内容 = "", 头像 = "png/ta/deepseek.png"})

    local header = {
      ["Content-Type"] = "application/json",
      ["Authorization"] = "Bearer sk-这里填key",
    }

    -- 构建请求体
    local data_body
    if 首次对话 == true then
      首次内容 = 编辑框.text
      data_body = {
        model = modelParams.model,
        messages = {
          {
            role = "user",
            content = 编辑框.text,
          },
        },
        stream = false,
        max_tokens = modelParams.max_tokens,
        temperature = modelParams.temperature,
        top_p = modelParams.top_p,
        top_k = modelParams.top_k,
        frequency_penalty = modelParams.frequency_penalty,
      }
     else
      data_body = {
        model = modelParams.model,
        messages = {
          {
            role = "user",
            content = 首次内容,
          },
          {
            role = "assistant",
            content = 回复内容,
          },
          {
            role = "user",
            content = 编辑框.text,
          },
        },
        stream = false,
        max_tokens = modelParams.max_tokens,
        temperature = modelParams.temperature,
        top_p = modelParams.top_p,
        top_k = modelParams.top_k,
        frequency_penalty = modelParams.frequency_penalty,
      }
    end
    local json_body = json.encode(data_body)

    Http.post("https://api.siliconflow.cn/v1/chat/completions", json_body, cookie, charset, header, function(code, body)
      删除信息(数据, 记录数值)
      if code == 200 then
        local json = json.decode(body)
        if json.choices[1].message.content == nil then
          写入信息(数据, {Who = "ta", 内容 = code .. "\n" .. body, 头像 = "png/ta/deepseek.png"})
         else
          写入信息(数据, {Who = "ta", 内容 = json.choices[1].message.content, 头像 = "png/ta/deepseek.png"})
          回复内容 = json.choices[1].message.content
        end
       else
        写入信息(数据, {Who = "ta", 内容 = "网络异常，请稍后再试\n" .. code, 头像 = "png/ta/deepseek.png"})
      end
    end)
    编辑框.text = ""
    首次对话 = false
  end
end

modelSettings.onClick = function()
  local dialogLayout = {
    LinearLayoutCompat,
    layout_width = "fill",
    layout_height = "wrap",
    orientation = "vertical",
    {
      TextView,
      layout_width = "fill",
      layout_height = "wrap",
      text = "模型设置",
      textSize = "20sp",
      padding = "10dp",
    },
    {
      Spinner,
      layout_width = "fill",
      layout_height = "wrap",
      id = "modelSpinner",
      entries = {"deepseek-ai/DeepSeek-V3", "fishaudio/fish-speech-1.5"},
    },
    {
      TextView,
      layout_width = "fill",
      layout_height = "wrap",
      text = "max_tokens",
    },
    {
      SeekBar,
      layout_width = "fill",
      layout_height = "wrap",
      id = "maxTokensSeekBar",
      max = 8192,
      progress = modelParams.max_tokens,
    },
    {
      TextView,
      layout_width = "fill",
      layout_height = "wrap",
      text = "temperature",
    },
    {
      SeekBar,
      layout_width = "fill",
      layout_height = "wrap",
      id = "temperatureSeekBar",
      max = 20,
      progress = modelParams.temperature * 10,
    },
    {
      TextView,
      layout_width = "fill",
      layout_height = "wrap",
      text = "top_p",
    },
    {
      SeekBar,
      layout_width = "fill",
      layout_height = "wrap",
      id = "topPSeekBar",
      max = 10,
      progress = modelParams.top_p * 10,
    },
    {
      TextView,
      layout_width = "fill",
      layout_height = "wrap",
      text = "top_k",
    },
    {
      SeekBar,
      layout_width = "fill",
      layout_height = "wrap",
      id = "topKSeekBar",
      max = 100,
      progress = modelParams.top_k,
    },
    {
      TextView,
      layout_width = "fill",
      layout_height = "wrap",
      text = "frequency_penalty",
    },
    {
      SeekBar,
      layout_width = "fill",
      layout_height = "wrap",
      id = "frequencyPenaltySeekBar",
      max = 40,
      progress = (modelParams.frequency_penalty + 2) * 10,
    },
    {
      LinearLayoutCompat,
      layout_width = "fill",
      layout_height = "wrap",
      orientation = "horizontal",
      gravity = "end",
      {
        Button,
        layout_width = "wrap_content",
        layout_height = "wrap_content",
        text = "取消",
        onClick = function(view)
          if dialog then
            dialog.dismiss()
          end
        end
      },
      {
        Button,
        layout_width = "wrap_content",
        layout_height = "wrap_content",
        text = "确定",
        onClick = function(view)
          -- 在这里获取 Spinner 对象
          local modelSpinner = dialog.findViewById("modelSpinner")
          if modelSpinner then
              local selectedItem = modelSpinner.getSelectedItem()
              if selectedItem then
                modelParams.model = selectedItem:toString()
              else
                print("Error: No item selected in modelSpinner")
                return -- 退出函数
              end
          else
              print("Error: modelSpinner not found in dialog")
              return -- 退出函数
          end

          local max_tokens = maxTokensSeekBar.getProgress()
          if type(max_tokens) == "number" then
            modelParams.max_tokens = max_tokens
          else
            print("Warning: maxTokensSeekBar.getProgress() returned invalid value. Using default: 100")
            modelParams.max_tokens = 100 -- 使用默认值
          end

          local temperature = temperatureSeekBar.getProgress() / 10
          if type(temperature) == "number" then
            modelParams.temperature = temperature
          else
            print("Warning: temperatureSeekBar.getProgress() returned invalid value. Using default: 0.7")
            modelParams.temperature = 0.7
          end

          local top_p = topPSeekBar.getProgress() / 10
          if type(top_p) == "number" then
            modelParams.top_p = top_p
          else
            print("Warning: topPSeekBar.getProgress() returned invalid value. Using default: 0.9")
            modelParams.top_p = 0.9
          end

          local top_k = topKSeekBar.getProgress()
          if type(top_k) == "number" then
            modelParams.top_k = top_k
          else
            print("Warning: topKSeekBar.getProgress() returned invalid value. Using default: 50")
            modelParams.top_k = 50
          end

          local frequency_penalty = frequencyPenaltySeekBar.getProgress() / 10 - 2
          if type(frequency_penalty) == "number" then
            modelParams.frequency_penalty = frequency_penalty
          else
            print("Warning: frequencyPenaltySeekBar.getProgress() returned invalid value. Using default: 0")
            modelParams.frequency_penalty = 0
          end


          if dialog then
            dialog.dismiss()
          end
        end
      },
    },
  }

  dialog = AlertDialog.Builder(activity)
  .setView(loadlayout(dialogLayout))
  .setCancelable(true)
  .create()

  -- 设置对话框的圆角
  dialog.getWindow().setBackgroundDrawableResource(android.R.color.transparent)
  local background = GradientDrawable()
  background.setColor(Color.WHITE)
  background.setCornerRadius(30)
  dialog.getWindow().setBackgroundDrawable(background)

  dialog.show()
end