require "vinx.core.Import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "Gh"
import "androidx.appcompat.widget.LinearLayoutCompat"


--归鸿   写的乱七八糟的，文档也没咋看，也不会写更好，多轮对话要把所有对话都写进去，我这里的方法是不成立的，没空在改了你们自己研究吧
local CoordinatorLayout = luajava.bindClass "androidx.coordinatorlayout.widget.CoordinatorLayout"
local AppBarLayout = luajava.bindClass "com.google.android.material.appbar.AppBarLayout"
local CollapsingToolbarLayout = luajava.bindClass "com.google.android.material.appbar.CollapsingToolbarLayout"
local NestedScrollView = luajava.bindClass "androidx.core.widget.NestedScrollView"
local MaterialToolbar = luajava.bindClass "com.google.android.material.appbar.MaterialToolbar"
local MaterialTextView = luajava.bindClass "com.google.android.material.textview.MaterialTextView"
local MaterialCardView = luajava.bindClass "com.google.android.material.card.MaterialCardView"
local TextInputEditText = luajava.bindClass "com.google.android.material.textfield.TextInputEditText"
local ImageFilterView = luajava.bindClass "androidx.constraintlayout.utils.widget.ImageFilterView"

--适配器
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



layout={
  LinearLayoutCompat,
  layout_width = 'fill', -- 布局宽度
  layout_height = 'fill', -- 布局高度
  orientation="vertical";
  {
    LinearLayoutCompat;
    layout_width="fill";
    layout_height="100dp";
    BackgroundColor="#EEEFF4";
    {
      MaterialTextView;
      layout_marginTop=状态栏高度();
      layout_gravity="left|center";
      text="异能AI",
      textSize="24dp";
      layout_margin = "15dp",
      textColor="0xff000000";
    };
  };
  {
    RecyclerView;
    layout_width="fill";
    layout_height="fill";
    id="recy";
    layout_weight="1";
  };
  {
    LinearLayoutCompat;
    layout_width="fill";
    layout_height="wrap";
    orientation="vertical";
    {
      LinearLayoutCompat;
      layout_width="fill";
      layout_height="wrap";
      layout_margin="10dp";
      {
        MaterialCardView;
        layout_gravity="center";
        radius="30dp";
        {
          MaterialTextView;
          layout_marginTop="5dp";
          layout_marginLeft="10dp";
          text="深度思考";
          layout_marginRight="10dp";
          layout_marginBottom="5dp";
        };
      };
      {
        MaterialTextView;
        layout_weight="1";
      };
      {
        CircleImageView;
        layout_gravity="center";
        layout_height="20dp";
        layout_width="20dp";
      };
    };
    {
      LinearLayoutCompat;
      layout_width="fill";
      layout_height="wrap";
      {
        LinearLayoutCompat;
        layout_width="fill";
        layout_height="wrap";
        layout_weight="1";
        {
          MaterialCardView;
          layout_marginLeft="10dp";
          radius="30dp";
          layout_gravity="center";
          layout_height="wrap_content";
          layout_width="match_parent";
          {
            TextInputEditText;
            layout_marginLeft="10dp";
            backgroundColor="0000";
            hint="请输入内容";
            gravity="left|top";
            layout_height="fill";
            layout_marginRight="10dp";
            textSize="14sp";
            layout_width="match_parent";
            id="编辑框";
          };
        };
      };
      {
        ImageView;
        layout_marginLeft="10dp";
        layout_width="30dp";
        layout_height="30dp";
        layout_marginRight="10dp";
        layout_gravity="center";
        id="发送";
      };
    };
  };
};



activity
.setTheme(R.style.Theme_Material3_Blue)
.setTitle("异能AI")
.setContentView(loadlayout(layout))
activity.getSupportActionBar().hide()
if Build.VERSION.SDK_INT >= 19 then
  activity.getWindow().addFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS);
end
activity.getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_ADJUST_PAN);
全局字体()


me={
  LinearLayoutCompat;
  layout_height="wrap";
  layout_width="fill";
  padding="10dp";
  gravity="right";
  {
    MaterialCardView;
    radius="30dp";
    layout_width="wrap";
    layout_height="wrap";
    layout_marginRight="10dp";
    {
      MaterialTextView;
      layout_marginTop="5dp";
      layout_marginBottom="5dp";
      layout_marginRight="10dp";
      layout_marginLeft="10dp";
      textSize="15sp";
      layout_height="wrap_content";
      layout_width="match_parent";
      id="内容";
      Typeface=字体1();
      textIsSelectable=true
    };
  };
  {
    MaterialCardView;
    radius="360";
    layout_width="35dp";
    layout_height="35dp";
    {
      ImageFilterView;
      layout_gravity="center";
      layout_width="25dp";
      layout_height="25dp";
      id="头像";
      round="360";
    };
  };
};



ta={
  LinearLayoutCompat;
  layout_height="wrap";
  layout_width="fill";
  padding="10dp";
  {
    MaterialCardView;
    radius="360";
    layout_width="35dp";
    layout_height="35dp";
    {
      ImageFilterView;
      layout_gravity="center";
      layout_width="25dp";
      layout_height="25dp";
      id="头像";
      round="360";
    };
  };
  {
    LinearLayoutCompat;
    orientation="vertical";
    layout_height="wrap_content";
    layout_width="fill";
    layout_marginLeft="10dp";
    {
      MaterialTextView;
      textSize="15sp";
      layout_height="wrap_content";
      layout_width="match_parent";
      id="内容";
      Typeface=字体1();
      textIsSelectable=true
    };
    {
      LinearLayoutCompat;
      layout_marginTop="10dp";
      layout_height="wrap_content";
      layout_width="wrap";
      {
        ImageView;
        layout_height="20dp";
        layout_width="20dp";
        src="png/1.png",
        id="复制";
      };
      {
        ImageView;
        layout_marginLeft="10dp";
        layout_height="20dp";
        layout_width="20dp";
        src="png/2.png";
      };
    };
  };
};


jiazai={
  LinearLayoutCompat;
  layout_height="wrap";
  layout_width="fill";
  padding="10dp";
  {
    MaterialCardView;
    radius="360";
    layout_width="35dp";
    layout_height="35dp";
    {
      ImageFilterView;
      layout_gravity="center";
      layout_width="25dp";
      layout_height="25dp";
      id="头像";
      round="360";
    };
  };
  {
    ImageView;
    layout_height="40dp";
    layout_width="200dp";
    id="加载";
  };
};

data={}


--初始数据
数据={
  {"Who":"ta","内容":"你好\n欢迎您使用异能AI\n您可以问我:今天天气怎么样或其他想问的问题","头像":"png/ta/deepseek.png"}
}
首次对话=true

function 写入信息(a,b)
  table.clear(data)
  table.insert(a,b)
  刷新数据()
end


function 删除信息(a,b)
  table.remove(a,b)
  刷新数据()
end



adp = LuaCustRecyclerAdapter(AdapterCreator({
  getItemCount=function()
    return #data
  end,
  getItemViewType=function(position)
    if 数据[position+1].Who == "me" then
      return 0
     elseif 数据[position+1].Who == "ta" then
      return 1
     elseif 数据[position+1].Who == "jiazai" then
      return 2
    end
  end,
  onCreateViewHolder=function(parent,viewType)
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
  onBindViewHolder=function(holder,position)
    local view=holder.view.getTag()
    local data = 数据[position+1]
    view.头像.setImageBitmap(loadbitmap(activity.getLuaDir() .. "/"..data.头像))
    if data.Who=="jiazai"
      view.加载.setImageDrawable(LottieDrawable("加载",0xff000000).loop(true).playAnimation());
     elseif data.Who=="me"
      view.内容.setText(data.内容)
     elseif data.Who=="ta"
      if position+1==记录数值
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
      view.复制.onClick=function(v)
        水珠动画(v,200)
        写入剪切板(data.内容)
        QQ提示("已复制内容")
      end
     else
    end
  end,
}))

recy.setAdapter(adp).setLayoutManager(StaggeredGridLayoutManager(1, 1))

function 刷新数据()
  记录数值=0
  for k,v in pairs(数据) do
    table.insert(data,数据[k])
    记录数值=记录数值+1
  end
  adp.notifyDataSetChanged()
end

刷新数据()

lottieDrawable = LottieDrawable("向上",0xff000000);
lottieDrawable.loop(false);
lottieDrawable.setMinFrame(60);
lottieDrawable.setMaxFrame(60);
lottieDrawable.playAnimation();
发送.setImageDrawable(lottieDrawable);


发送.onClick=function()
  if 编辑框.text==""
    QQ提示("输入内容不得为空")
   else
    写入信息(数据,{Who = "me", 内容 = 编辑框.text, 头像 = "png/me/7h.png"})
    写入信息(数据,{Who = "jiazai", 内容 = "", 头像 = "png/ta/deepseek.png"})

    local header = {
      ["Content-Type"] = "application/json",
      ["Authorization"] = "Bearer sk-这里填key"
    }

    -- 构建请求体
    if 首次对话==true
      首次内容=编辑框.text
      data_body = {
        stream = false,
        --temperature = 0.3,
        model = "deepseek-chat",
        messages = {
          {
            role = "user",
            content = 编辑框.text
          }
        }
      }
     else
      data_body = {
        stream = false,
        --temperature = 0.3,
        model = "deepseek-chat",
        messages = {
          {
            role = "user",
            content = 首次内容
          },
          {
            role = "assistant",
            content = 回复内容
          },
          {
            role = "user",
            content = 编辑框.text
          }
        }
      }
    end
    local json_body = cjson.encode(data_body)

    Http.post("https://api.deepseek.com/chat/completions",json_body,cookie,charset,header,function(code,body)
      删除信息(数据,记录数值)
      if code==200
        local json=cjson.decode(body)
        if json.choices[1].message.content==nil
          写入信息(数据,{Who = "ta", 内容 = code.."\n"..body, 头像 = "png/ta/deepseek.png"})
         else
          写入信息(数据,{Who = "ta", 内容 = json.choices[1].message.content, 头像 = "png/ta/deepseek.png"})
          回复内容=json.choices[1].message.content
        end
       else
        写入信息(数据,{Who = "ta", 内容 = "网络异常，请稍后再试\n"..code, 头像 = "png/ta/deepseek.png"})
      end
    end)
    编辑框.text=""
    首次对话=false
  end
end