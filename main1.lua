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

local SharedPreferences = activity.getSharedPreferences("app_prefs", Context.MODE_PRIVATE)

-- 读取缓存的 key
local cachedKey = SharedPreferences.getString("api_key", "")

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

local header = {
  ["Content-Type"] = "application/json",
  ["Authorization"] = "Bearer sk-这里填key",
}

-- 增加日志
print("Header: " .. json.encode(header))


发送.onClick = function()
  if 编辑框.text == "" then
    QQ提示("输入内容不得为空")
   else
    写入信息(数据, {Who = "me", 内容 = 编辑框.text, 头像 = "png/me/7h.png"})
    写入信息(数据, {Who = "jiazai", 内容 = "", 头像 = "png/ta/deepseek.png"})

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

    -- 打印请求体
    print("Request Body: " .. json_body)
    print("Header: " .. json.encode(header))

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
  -- 创建对话框的布局
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
      textSize = "24sp",
      padding = "20dp",
      gravity = "center",
    },
    {
      TextInputEditText,
      layout_width = "fill",
      layout_height = "wrap",
      hint = "请输入Key",
      id = "keyInput",
      text = cachedKey,
    },
    {
      Spinner,
      layout_width = "fill",
      layout_height = "wrap",
      id = "modelSpinner",
    },
    {
      LinearLayoutCompat,
      layout_width = "fill",
      layout_height = "wrap",
      orientation = "horizontal",
      gravity = "center",
      {
        TextView,
        layout_width = "wrap_content",
        layout_height = "wrap",
        text = "文本长度",
        textSize = "18sp",
        layout_marginTop = "10dp",
        layout_marginBottom = "10dp",
      },
      {
        TextView,
        layout_width = "80dp",
        layout_height = "wrap",
        id = "maxTokensValue",
        text = tostring(modelParams.max_tokens),
        textSize = "18sp",
        gravity = "center",
        backgroundColor = "#EEEFF4",
        padding = "5dp",
        layout_marginLeft = "10dp",
      },
    },
    {
      SeekBar,
      layout_width = "fill",
      layout_height = "wrap",
      id = "maxTokensSeekBar",
      min = 1,
      max = 8192,
      progress = modelParams.max_tokens, -- Retrieve saved value
      onSeekBarChangeListener = {
        onProgressChanged = function(seekBar, progress, fromUser)
          maxTokensValue.setText(tostring(progress))
        end,
      },
    },
    {
      LinearLayoutCompat,
      layout_width = "fill",
      layout_height = "wrap",
      orientation = "horizontal",
      gravity = "center",
      {
        TextView,
        layout_width = "wrap_content",
        layout_height = "wrap",
        text = "temperature",
        textSize = "18sp",
        layout_marginTop = "10dp",
        layout_marginBottom = "10dp",
      },
      {
        TextView,
        layout_width = "50dp",
        layout_height = "wrap",
        id = "temperatureValue",
        text = tostring(modelParams.temperature),
        textSize = "18sp",
        gravity = "center",
        backgroundColor = "#EEEFF4",
        padding = "5dp",
        layout_marginLeft = "10dp",
      },
    },
    {
      SeekBar,
      layout_width = "fill",
      layout_height = "wrap",
      id = "temperatureSeekBar",
      min = 0,
      max = 20,
      progress = modelParams.temperature * 10,
      onSeekBarChangeListener = {
        onProgressChanged = function(seekBar, progress, fromUser)
          temperatureValue.setText(tostring(progress / 10))
        end,
      },
    },
    {
      LinearLayoutCompat,
      layout_width = "fill",
      layout_height = "wrap",
      orientation = "horizontal",
      gravity = "center",
      {
        TextView,
        layout_width = "wrap_content",
        layout_height = "wrap",
        text = "top_p",
        textSize = "18sp",
        layout_marginTop = "10dp",
        layout_marginBottom = "10dp",
      },
      {
        TextView,
        layout_width = "50dp",
        layout_height = "wrap",
        id = "topPValue",
        text = tostring(modelParams.top_p),
        textSize = "18sp",
        gravity = "center",
        backgroundColor = "#EEEFF4",
        padding = "5dp",
        layout_marginLeft = "10dp",
      },
    },
    {
      SeekBar,
      layout_width = "fill",
      layout_height = "wrap",
      id = "topPSeekBar",
      min = 1,
      max = 10,
      progress = modelParams.top_p * 10,
      onSeekBarChangeListener = {
        onProgressChanged = function(seekBar, progress, fromUser)
          topPValue.setText(tostring(progress / 10))
        end,
      },
    },
    {
      LinearLayoutCompat,
      layout_width = "fill",
      layout_height = "wrap",
      orientation = "horizontal",
      gravity = "center",
      {
        TextView,
        layout_width = "wrap_content",
        layout_height = "wrap",
        text = "top_k",
        textSize = "18sp",
        layout_marginTop = "10dp",
        layout_marginBottom = "10dp",
      },
      {
        TextView,
        layout_width = "50dp",
        layout_height = "wrap",
        id = "topKValue",
        text = tostring(modelParams.top_k),
        textSize = "18sp",
        gravity = "center",
        backgroundColor = "#EEEFF4",
        padding = "5dp",
        layout_marginLeft = "10dp",
      },
    },
    {
      SeekBar,
      layout_width = "fill",
      layout_height = "wrap",
      id = "topKSeekBar",
      min = 0,
      max = 100,
      progress = modelParams.top_k,
      onSeekBarChangeListener = {
        onProgressChanged = function(seekBar, progress, fromUser)
          topKValue.setText(tostring(progress))
        end,
      },
    },
    {
      LinearLayoutCompat,
      layout_width = "fill",
      layout_height = "wrap",
      orientation = "horizontal",
      gravity = "center",
      {
        TextView,
        layout_width = "wrap_content",
        layout_height = "wrap",
        text = "frequency_penalty",
        textSize = "18sp",
        layout_marginTop = "10dp",
        layout_marginBottom = "10dp",
      },
      {
        TextView,
        layout_width = "50dp",
        layout_height = "wrap",
        id = "frequencyPenaltyValue",
        text = tostring(modelParams.frequency_penalty),
        textSize = "18sp",
        gravity = "center",
        backgroundColor = "#EEEFF4",
        padding = "5dp",
        layout_marginLeft = "10dp",
      },
    },
    {
      SeekBar,
      layout_width = "fill",
      layout_height = "wrap",
      id = "frequencyPenaltySeekBar",
      min = 0, -- 滑动条的最小值
      max = 40, -- 滑动条的最大值
      progress = (modelParams.frequency_penalty + 2) * 10, -- 默认值映射
      onSeekBarChangeListener = {
        onProgressChanged = function(seekBar, progress, fromUser)
          -- 将 progress 映射到 -2.0 到 2.0
          frequencyPenaltyValue.setText(tostring((progress / 10) - 2))
        end,
      },
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
          dialog.dismiss()
        end
      },
      {
        Button,
        layout_width = "wrap_content",
        layout_height = "wrap_content",
        text = "确定",
        onClick = function(view)
          local selectedModel = modelSpinner.getSelectedItem()
          local keyInput = keyInput.getText().toString()
          if selectedModel then
            modelParams.model = tostring(selectedModel)
           else
            QQ提示("请选择一个模型")
            return
          end
          if keyInput ~= "" then
            header["Authorization"] = "Bearer " .. keyInput
            -- Save key to SharedPreferences
            local editor = SharedPreferences.edit()
            editor.putString("api_key", keyInput)
            editor.apply()
          end
          modelParams.max_tokens = maxTokensSeekBar.getProgress()
          modelParams.temperature = temperatureSeekBar.getProgress() / 10
          modelParams.top_p = topPSeekBar.getProgress() / 10
          modelParams.top_k = topKSeekBar.getProgress()
          modelParams.frequency_penalty = frequencyPenaltySeekBar.getProgress() / 10 - 2
          dialog.dismiss()
          QQ提示("模型参数已保存")
        end
      },
    },
  }

  -- 创建对话框
  -- 创建对话框
  dialog = AlertDialogBuilder(this)
  dialog.setView(loadlayout(dialogLayout))
  dialog = dialog.show()

  -- 设置 Spinner 的适配器
  local adapter = ArrayAdapter(this, android.R.layout.simple_spinner_item, {
    "deepseek-ai/DeepSeek-R1",
    "Pro/deepseek-ai/DeepSeek-R1",
    "deepseek-ai/DeepSeek-V3",
    "Pro/deepseek-ai/DeepSeek-V3",
    "deepseek-ai/DeepSeek-R1-Distill-Llama-70B",
    "deepseek-ai/DeepSeek-R1-Distill-Qwen-32B",
    "deepseek-ai/DeepSeek-R1-Distill-Qwen-14B",
    "deepseek-ai/DeepSeek-R1-Distill-Llama-8B",
    "deepseek-ai/DeepSeek-R1-Distill-Qwen-7B",
    "deepseek-ai/DeepSeek-R1-Distill-Qwen-1.5B",
    "Pro/deepseek-ai/DeepSeek-R1-Distill-Llama-8B",
    "Pro/deepseek-ai/DeepSeek-R1-Distill-Qwen-7B",
    "Pro/deepseek-ai/DeepSeek-R1-Distill-Qwen-1.5B",
    "meta-llama/Llama-3.3-70B-Instruct",
    "AIDC-AI/Marco-o1",
    "deepseek-ai/DeepSeek-V2.5",
    "Qwen/Qwen2.5-72B-Instruct-128K",
    "Qwen/Qwen2.5-72B-Instruct",
    "Qwen/Qwen2.5-32B-Instruct",
    "Qwen/Qwen2.5-14B-Instruct",
    "Qwen/Qwen2.5-7B-Instruct",
    "Qwen/Qwen2.5-Coder-32B-Instruct",
    "Qwen/Qwen2.5-Coder-7B-Instruct",
    "Qwen/Qwen2-7B-Instruct",
    "Qwen/Qwen2-1.5B-Instruct",
    "Qwen/QwQ-32B-Preview",
    "TeleAI/TeleChat2",
    "01-ai/Yi-1.5-34B-Chat-16K",
    "01-ai/Yi-1.5-9B-Chat-16K",
    "01-ai/Yi-1.5-6B-Chat",
    "THUDM/glm-4-9b-chat",
    "Vendor-A/Qwen/Qwen2.5-72B-Instruct",
    "internlm/internlm2_5-7b-chat",
    "internlm/internlm2_5-20b-chat",
    "nvidia/Llama-3.1-Nemotron-70B-Instruct",
    "meta-llama/Meta-Llama-3.1-405B-Instruct",
    "meta-llama/Meta-Llama-3.1-70B-Instruct",
    "meta-llama/Meta-Llama-3.1-8B-Instruct",
    "google/gemma-2-27b-it",
    "google/gemma-2-9b-it",
    "Pro/Qwen/Qwen2.5-7B-Instruct",
    "Pro/Qwen/Qwen2-7B-Instruct",
    "Pro/Qwen/Qwen2-1.5B-Instruct",
    "Pro/THUDM/chatglm3-6b",
    "Pro/THUDM/glm-4-9b-chat",
    "Pro/meta-llama/Meta-Llama-3.1-8B-Instruct",
    "Pro/google/gemma-2-9b-it"
  })
  adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item)
  modelSpinner.setAdapter(adapter)

  -- 设置对话框的圆角
  dialog.getWindow().setBackgroundDrawableResource(android.R.color.transparent)
  local background = GradientDrawable()
  background.setColor(Color.WHITE)
  background.setCornerRadius(30)
  dialog.getWindow().setBackgroundDrawable(background)

  dialog.show()
end
