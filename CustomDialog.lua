local CustomDialog = {}

import "android.app.Dialog"
import "android.view.ViewGroup"
import "android.view.Gravity"
import "android.widget.LinearLayout"
import "android.widget.TextView"
import "android.widget.Button"
import "android.widget.EditText"
import "android.widget.SeekBar"
import "android.widget.Spinner"
import "android.widget.Switch"
import "android.widget.ArrayAdapter"
import "android.util.TypedValue"
import "android.graphics.drawable.GradientDrawable"
import "android.content.Context"

local dialog

-- dp 转 px（适配不同屏幕）
local function dpToPx(activity, dp)
  return TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, dp, activity.getResources().getDisplayMetrics())
end

-- 创建圆角背景
local function createRoundedBackground(color, radius)
  local drawable = GradientDrawable()
  drawable.setShape(GradientDrawable.RECTANGLE)
  drawable.setColor(color)
  drawable.setCornerRadius(radius)
  return drawable
end

local function createRoundedBackground1(color, radius)
  local drawable = GradientDrawable()
  drawable.setShape(GradientDrawable.RECTANGLE)
  drawable.setColor(color)
  drawable.setCornerRadius(radius)
  drawable.setStroke(dpToPx(activity, 1), 0xFFCCCCCC)
  return drawable
end

-- 创建输入框（带美化）
local function createInputField(activity, hint)
  local input = EditText(activity)
  input.setHint(hint)
  input.setSingleLine(true)
  input.setPadding(dpToPx(activity, 12), dpToPx(activity, 10), dpToPx(activity, 12), dpToPx(activity, 10))
  input.setTextSize(16)
  input.setBackgroundDrawable(createRoundedBackground1(0xFFFFFFFF, dpToPx(activity, 8))) -- 白色背景，圆角
  return input
end

-- 创建下拉选择框
local function createSpinner(activity, items, defaultIndex)
  local spinner = Spinner(activity)
  local adapter = ArrayAdapter(activity, android.R.layout.simple_spinner_item, items)
  adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item)
  spinner.setAdapter(adapter)
  spinner.setSelection(defaultIndex)
  spinner.setPadding(dpToPx(activity, 12), dpToPx(activity, 10), dpToPx(activity, 12), dpToPx(activity, 10))
  spinner.setBackgroundDrawable(createRoundedBackground1(0xFFFFFFFF, dpToPx(activity, 8))) -- 圆角白色背景

  -- 设置固定宽度 241dp
  local layoutParams = LinearLayout.LayoutParams(dpToPx(activity, 241), LinearLayout.LayoutParams.WRAP_CONTENT)
  spinner.setLayoutParams(layoutParams)

  return spinner
end

-- 创建滑动条
local function createSlider(activity, title, defaultValue, min, max, step)
  local container = LinearLayout(activity)
  container.setOrientation(LinearLayout.VERTICAL)

  local topLayout = LinearLayout(activity)
  topLayout.setOrientation(LinearLayout.HORIZONTAL)
  topLayout.setGravity(Gravity.CENTER_VERTICAL)

  local textView = TextView(activity)
  textView.setText(title)
  textView.setTextSize(16)
  textView.setGravity(Gravity.LEFT)

  local valueView = TextView(activity)
  valueView.setText(defaultValue % 1 == 0 and string.format("%d", defaultValue) or string.format("%.1f", defaultValue))
  valueView.setTextSize(14)
  valueView.setWidth(dpToPx(activity, 50))
  valueView.setHeight(dpToPx(activity, 27))
  valueView.setGravity(Gravity.CENTER)
  valueView.setPadding(dpToPx(activity, 8), dpToPx(activity, 4), dpToPx(activity, 8), dpToPx(activity, 4))
  valueView.setBackgroundDrawable(createRoundedBackground1(0xFFEEEEEE, dpToPx(activity, 8)))
  valueView.setTextColor(0xFF333333)

  local seekBar = SeekBar(activity)
  seekBar.setMax((max - min) / step)
  seekBar.setProgress((defaultValue - min) / step)

  seekBar.setOnSeekBarChangeListener{
    onProgressChanged = function(_, progress)
      local value = min + progress * step
      valueView.setText(value % 1 == 0 and string.format("%d", value) or string.format("%.1f", value))
    end
  }

  local layoutParams = LinearLayout.LayoutParams(0, ViewGroup.LayoutParams.WRAP_CONTENT, 1)
  textView.setLayoutParams(layoutParams)

  local valueParams = LinearLayout.LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT)
  valueParams.setMargins(dpToPx(activity, 6), 0, 0, 0)
  valueView.setLayoutParams(valueParams)

  topLayout.addView(textView)
  topLayout.addView(valueView)

  container.addView(topLayout)
  container.addView(seekBar)

  return container, seekBar, valueView, defaultValue
end

-- 创建开关（Stream）
local function createSwitch(activity, label, defaultValue)
  local container = LinearLayout(activity)
  container.setOrientation(LinearLayout.HORIZONTAL)
  container.setGravity(Gravity.CENTER_VERTICAL) -- 垂直居中

  -- 文本
  local textView = TextView(activity)
  textView.setText(label)
  textView.setTextSize(16)

  -- 设置 TextView 的 LayoutParams，使其占满剩余空间
  local textParams = LinearLayout.LayoutParams(0, ViewGroup.LayoutParams.WRAP_CONTENT, 1)
  textView.setLayoutParams(textParams)

  -- 开关
  local streamSwitch = Switch(activity)
  
  -- 设置开关的 LayoutParams，确保它靠右
  local switchParams = LinearLayout.LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT)
  streamSwitch.setLayoutParams(switchParams)

  -- 设置开关的默认状态
  streamSwitch.setChecked(defaultValue)

  -- 添加视图
  container.addView(textView)
  container.addView(streamSwitch)

  return container, streamSwitch
end

-- 保存配置到 SharedPreferences
local function savePreferences(activity, apiKey, selectedModel, maxTokens, temperature, topP, topK, frequencyPenalty, stream)
  local prefs = activity.getSharedPreferences("CustomDialogPrefs", Context.MODE_PRIVATE)
  local editor = prefs.edit()
  editor.putString("apiKey", apiKey)
  editor.putString("selectedModel", selectedModel)
  editor.putInt("maxTokens", maxTokens)
  editor.putFloat("temperature", temperature)
  editor.putFloat("topP", topP)
  editor.putInt("topK", topK)
  editor.putFloat("frequencyPenalty", frequencyPenalty)
  editor.putBoolean("stream", stream) -- 保存 stream 状态
  editor.apply()
end

-- 读取配置从 SharedPreferences
local function loadPreferences(activity)
  local prefs = activity.getSharedPreferences("CustomDialogPrefs", Context.MODE_PRIVATE)
  return {
    apiKey = prefs.getString("apiKey", ""),
    selectedModel = prefs.getString("selectedModel", "deepseek-ai/DeepSeek-V3"),
    maxTokens = prefs.getInt("maxTokens", 512),
    temperature = prefs.getFloat("temperature", 0.7),
    topP = prefs.getFloat("topP", 0.7),
    topK = prefs.getInt("topK", 50),
    frequencyPenalty = prefs.getFloat("frequencyPenalty", 0.5),
    stream = prefs.getBoolean("stream", false) -- 读取 stream 状态
  }
end

-- 显示自定义对话框
function CustomDialog.show(activity, onConfirm, cancelable)
  if dialog then
    dialog.dismiss()
    dialog = nil
  end

  -- 加载保存的配置
  local preferences = loadPreferences(activity)

  -- 创建对话框
  dialog = Dialog(activity)
  dialog.setCancelable(cancelable ~= false)
  dialog.setCanceledOnTouchOutside(cancelable ~= false)

  local window = dialog.getWindow()
  if window then
    window.setBackgroundDrawableResource(android.R.color.transparent)
  end

  -- 对话框样式
  local bgColor = 0xFFF7E6E6 -- 浅粉色背景
  local radius = dpToPx(activity, 12) -- 圆角半径
  local padding = dpToPx(activity, 20)

  -- 固定对话框宽高
  local dialogWidth = dpToPx(activity, 294)
  local dialogHeight = dpToPx(activity, 491)

  local layout = LinearLayout(activity)
  layout.setOrientation(LinearLayout.VERTICAL)
  layout.setGravity(Gravity.TOP)
  layout.setPadding(padding, padding, padding, padding)
  layout.setBackgroundDrawable(createRoundedBackground(bgColor, radius))

  -- 固定宽高
  local params = LinearLayout.LayoutParams(dialogWidth, dialogHeight)

  -- 标题
  local titleView = TextView(activity)
  titleView.setText("参数配置")
  titleView.setTextSize(20)
  titleView.setGravity(Gravity.CENTER)
  titleView.setTextColor(0xFF222222)
  titleView.setPadding(0, dpToPx(activity, 1), 0, dpToPx(activity, 15))
  layout.addView(titleView)

  -- API Key 输入框
  local apiKeyInput = createInputField(activity, "请输入 API Key")
  apiKeyInput.setText(preferences.apiKey)
  layout.addView(apiKeyInput)

  -- 增加 5dp 间距
  local spaceView = TextView(activity)
  spaceView.setHeight(dpToPx(activity, 5))
  layout.addView(spaceView)

  -- 下拉选择框
  local modelSpinner = createSpinner(activity, {"deepseek-ai/DeepSeek-V3", "fishaudio/fish-speech-1.5"}, 0)
  modelSpinner.setSelection(preferences.selectedModel == "deepseek-ai/DeepSeek-V3" and 0 or 1)
  layout.addView(modelSpinner)

  -- 增加 5dp 间距
  spaceView = TextView(activity)
  spaceView.setHeight(dpToPx(activity, 5))
  layout.addView(spaceView)

  -- max_tokens 滑动条
  local maxTokensLayout, maxTokensSeek, maxTokensValue, maxTokensDefault = createSlider(activity, "文本长度", preferences.maxTokens, 1, 8192, 1)
  layout.addView(maxTokensLayout)

  -- 增加 5dp 间距
  spaceView = TextView(activity)
  spaceView.setHeight(dpToPx(activity, 5))
  layout.addView(spaceView)

  -- temperature 滑动条
  local tempLayout, tempSeek, tempValue, tempDefault = createSlider(activity, "文本随机性", preferences.temperature, 0, 2, 0.01)
  layout.addView(tempLayout)

  -- 增加 5dp 间距
  spaceView = TextView(activity)
  spaceView.setHeight(dpToPx(activity, 5))
  layout.addView(spaceView)

  -- top_p 滑动条
  local topPLayout, topPSeek, topPValue, topPDefault = createSlider(activity, "top_p", preferences.topP, 0.1, 1, 0.01)
  layout.addView(topPLayout)

  -- 增加 5dp 间距
  spaceView = TextView(activity)
  spaceView.setHeight(dpToPx(activity, 5))
  layout.addView(spaceView)

  -- top_k 滑动条
  local topKLayout, topKSeek, topKValue, topKDefault = createSlider(activity, "top_k", preferences.topK, 0, 100, 1)
  layout.addView(topKLayout)

  -- 增加 5dp 间距
  spaceView = TextView(activity)
  spaceView.setHeight(dpToPx(activity, 5))
  layout.addView(spaceView)

  -- 频率惩罚滑动条
  local freqLayout, freqSeek, freqValue, freqDefault = createSlider(activity, "frequency_penalty", preferences.frequencyPenalty, -2.0, 2.0, 0.01)
  layout.addView(freqLayout)

  -- 增加 5dp 间距
  spaceView = TextView(activity)
  spaceView.setHeight(dpToPx(activity, 5))
  layout.addView(spaceView)
  
  -- 添加 Stream 开关
  local streamSwitchLayout, streamSwitch = createSwitch(activity, "启用流式输出", preferences.stream)
  layout.addView(streamSwitchLayout)
  
  -- 增加 5dp 间距
  spaceView = TextView(activity)
  spaceView.setHeight(dpToPx(activity, 5))
  layout.addView(spaceView)

  -- 按钮布局
  local buttonLayout = LinearLayout(activity)
  buttonLayout.setOrientation(LinearLayout.HORIZONTAL)
  buttonLayout.setGravity(Gravity.END)
  buttonLayout.setPadding(0, 20, 0, 0)

  local buttonParams = LinearLayout.LayoutParams(0, ViewGroup.LayoutParams.WRAP_CONTENT, 1)
  buttonParams.setMargins(dpToPx(activity, 8), 0, dpToPx(activity, 8), 0)

  -- 取消按钮
  local cancelButton = Button(activity)
  cancelButton.setText("取消")
  cancelButton.setLayoutParams(LinearLayout.LayoutParams(dpToPx(activity, 64), dpToPx(activity, 48)))
  cancelButton.setBackgroundDrawable(nil)

  -- 确定按钮
  local confirmButton = Button(activity)
  confirmButton.setText("确定")
  confirmButton.setLayoutParams(buttonParams)
  confirmButton.setBackgroundDrawable(nil)
  confirmButton.setLayoutParams(LinearLayout.LayoutParams(dpToPx(activity, 64), dpToPx(activity, 48)))
  confirmButton.setOnClickListener(function()
    if type(onConfirm) == "function" then
      local apiKey = apiKeyInput.getText().toString()
      local selectedModel = tostring(modelSpinner.getSelectedItem())

      -- 修正滑条参数计算
      local maxTokens = 1 + maxTokensSeek.getProgress() * 1 -- min + progress * step
      local temperature = 0 + tempSeek.getProgress() * 0.01
      local topP = 0.1 + topPSeek.getProgress() * 0.01
      local topK = 0 + topKSeek.getProgress() * 1
      local frequencyPenalty = -2.0 + freqSeek.getProgress() * 0.01
      local stream = streamSwitch.isChecked()

      -- 保存配置
      savePreferences(activity, apiKey, selectedModel, maxTokens, temperature, topP, topK, frequencyPenalty, stream)

      -- 传递正确的参数
      onConfirm(apiKey, selectedModel, maxTokens, temperature, topP, topK, frequencyPenalty, stream)
     else
      print("警告: onConfirm 不是一个有效的函数，忽略点击事件")
    end
    dialog.dismiss()

  end)

  cancelButton.setOnClickListener(function() dialog.dismiss() end)

  buttonLayout.addView(cancelButton)
  buttonLayout.addView(confirmButton)
  layout.addView(buttonLayout)

  -- 设置对话框内容并显示
  dialog.setContentView(layout)
  dialog.show()
end

return CustomDialog

