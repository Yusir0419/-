require "vinx.core.Import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "Gh"
import "androidx.appcompat.widget.LinearLayoutCompat"
import "fun.ocss.markdown.MarkdownView"
--归鸿  549行输入你的key    写的很乱勿喷，流试输出写不出来，加载历史对话后继续对话(多轮对话)有bug发出信息回复不了，有空在修

历史路径 = activity.getLuaDir() .. "/AppData/ls.json"
file,err=io.open(历史路径)
if err==nil then
 else
  io.open(历史路径,"w"):write("{}"):close()
end


local CoordinatorLayout = luajava.bindClass "androidx.coordinatorlayout.widget.CoordinatorLayout"
local AppBarLayout = luajava.bindClass "com.google.android.material.appbar.AppBarLayout"
local CollapsingToolbarLayout = luajava.bindClass "com.google.android.material.appbar.CollapsingToolbarLayout"
local NestedScrollView = luajava.bindClass "androidx.core.widget.NestedScrollView"
local MaterialToolbar = luajava.bindClass "com.google.android.material.appbar.MaterialToolbar"
local MaterialTextView = luajava.bindClass "com.google.android.material.textview.MaterialTextView"
local MaterialCardView = luajava.bindClass "com.google.android.material.card.MaterialCardView"
local TextInputEditText = luajava.bindClass "com.google.android.material.textfield.TextInputEditText"
local ImageFilterView = luajava.bindClass "androidx.constraintlayout.utils.widget.ImageFilterView"
local DrawerLayout = luajava.bindClass "androidx.drawerlayout.widget.DrawerLayout"
local NavigationView = luajava.bindClass "com.google.android.material.navigation.NavigationView"
local SearchView = luajava.bindClass "androidx.appcompat.widget.SearchView"

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
  DrawerLayout;
  id="drawerLayout";
  layout_width="fill";
  layout_height="fill";
  {
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
        onClick=function()
          drawerLayout.openDrawer(3)
        end;
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
            text="推理模型";
            layout_marginRight="10dp";
            layout_marginBottom="5dp";
          };
        };
        {
          MaterialTextView;
          layout_weight="1";
        };
        {
          ImageView;
          layout_marginRight="5dp";
          layout_gravity="center";
          layout_height="25dp";
          layout_width="25dp";
          src="png/5.png";
          id="新建对话";
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
          layout_width="35dp";
          layout_height="35dp";
          layout_marginRight="10dp";
          layout_gravity="center";
          id="发送";
        };
      };
    };
  };
  {
    NavigationView;
    id="nav_view",
    layout_width="wrap_content",
    layout_height="match_parent",
    layout_gravity="start",
    fitsSystemWindows="true",
    {
      LinearLayoutCompat;
      layout_width="fill";
      layout_height="fill";
      orientation="vertical";
      layout_margin="10dp";
      {
        LinearLayoutCompat;
        layout_width="fill";
        layout_height="wrap";
        layout_marginTop=状态栏高度();
        {
          MaterialCardView;
          layout_width="35dp";
          radius="360";
          layout_height="35dp";
          {
            ImageFilterView;
            round="360";
            layout_gravity="center";
            layout_width="25dp";
            layout_height="25dp";
            src="png/me/Qy.png";
          };
        };
        {
          MaterialTextView;
          text="异能游客";
          layout_gravity="center";
          layout_weight="1";
          layout_marginLeft="10dp";
        };
        {
          ImageFilterView;
          layout_gravity="center";
          layout_height="35dp";
          layout_width="35dp";
          round="360";
          src="png/4.png";
        };
      };
      {
        MaterialCardView;
        layout_marginTop="10dp";
        layout_width="fill";
        radius="10dp";
        layout_height="wrap";
        {
          SearchView;
          layout_width='fill';--控件宽度
          layout_height='wrap';--控件高度
          id='Search';
          queryHint='请输入关键字';
          maxWidth='fill';--最大宽度
        };
      };
      {
        RecyclerView;
        layout_width="fill";
        layout_height="fill";
        id="recy1";
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


Search.setQueryHint('输入搜索内容')
Search.setIconified(false);



--隐藏下划线,背景变透明
function SearchColor(id)
  import "android.graphics.Color"
  local argClass = id.getClass();
  local ownField = argClass.getDeclaredField("mSearchPlate");
  ownField.setAccessible(true);
  local mView = ownField.get(id);
  mView.setBackgroundColor(Color.TRANSPARENT);
end
SearchColor(Search)


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
      --[[MaterialTextView;
      textSize="15sp";
      layout_height="wrap_content";
      layout_width="match_parent";
      id="内容";
      Typeface=字体1();
      textIsSelectable=true
    };
    {]]
      MaterialCardView;
      radius="10dp";
      layout_height="wrap_content";
      layout_width="match_parent";
      BackgroundColor="0xffffffff";
      {
        MarkdownView,
        layout_marginTop="10dp";
        layout_height="wrap_content";
        layout_width="match_parent";
        id="内容";
      };
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


--初始数据
function 初始化()
  data={}
  对话={}
  数据={
    {"Who":"ta","内容":"你好<br>欢迎您使用异能AI<br>您可以问我:今天天气怎么样或其他想问的问题","头像":"png/ta/deepseek.png"}
  }
  是否新窗口=true
end
初始化()

function 刷新历史()
  读取历史={}
  读取历史=cjson.decode(io.open(历史路径):read("*a"))
end
刷新历史()

选择历史=#读取历史+1

function 加载历史(nb)
  选择历史=nb
  是否新窗口=false
  table.clear(data)
  数据={}
  for k,v in ipairs(读取历史[nb].data) do
    table.insert(数据,v)
    if v.Who=="me"
      多轮对话组合("user",v.内容)
     else
      多轮对话组合("assistant",v.内容)
    end
  end
  刷新数据()
end


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
    view.头像.setImageBitmap(loadbitmap(activity.getLuaDir() .. "/"..data.头像:gsub("\\","")))
    if data.Who=="jiazai"
      view.加载.setImageDrawable(LottieDrawable("加载",0xff000000).loop(true).playAnimation());
     elseif data.Who=="me"
      view.内容.setText(data.内容)
     elseif data.Who=="ta"
      view.内容.loadFromText(data.内容)
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
  for k,v in pairs(数据) do
    table.insert(data,数据[k])
  end
  recy.scrollToPosition(adp.getItemCount() - 1)
  adp.notifyDataSetChanged()
end

刷新数据()


发送.setImageBitmap(loadbitmap(activity.getLuaDir() .. "/png/3.png"))





function 多轮对话组合(对象,发言)
  table.insert(对话,
  {
    role = 对象,
    content = 发言
  })
end





发送.onClick=function()
  隐藏输入法(编辑框)
  if 编辑框.text==""
    QQ提示("输入内容不得为空")
   else
    记录输入内容=编辑框.text
    发送.setEnabled(false)--禁止被触摸
    发送.setImageDrawable(LottieDrawable("等待").loop(true).playAnimation());
    多轮对话组合("user",编辑框.text)
    print(dump(对话))
    写入信息(数据,{Who = "me", 内容 = 编辑框.text, 头像 = "png/me/7h.png"})
    写入信息(数据,{Who = "jiazai", 内容 = "", 头像 = "png/ta/deepseek.png"})
    local header = {
      ["Content-Type"] = "application/json",
      ["Authorization"] = "Bearer 这里输入你的key"
    }
    data_body = {
      stream = false,
      --temperature = 0.3,
      model = "deepseek-chat",
      messages =对话
    }
    local json_body = cjson.encode(data_body)
    
    
    
    print("Request Body: " .. json_body)

    Http.post("https://api.deepseek.com/chat/completions",json_body,cookie,charset,header,function(code,body)
      print(code,body)
      删除信息(数据,记录数值)
      if code==200
        local json=cjson.decode(body)
        if json.choices[1].message.content==nil
          写入信息(数据,{Who = "ta", 内容 = code.."\n"..body, 头像 = "png/ta/deepseek.png"})
         else
          写入信息(数据,{Who = "ta", 内容 = json.choices[1].message.content, 头像 = "png/ta/deepseek.png"})
          多轮对话组合("assistant",json.choices[1].message.content)
          if 是否新窗口==true
            table.insert(读取历史,{
              model = json.model,
              time = os.time(),
              data = {
                {"Who":"me","内容":记录输入内容,"头像":"png/me/7h.png"},
                {"Who":"ta","内容":json.choices[1].message.content,"头像":"png/ta/deepseek.png"}
              }
            })
            io.open(历史路径,"w"):write(cjson.encode(读取历史)):close()
            刷新历史()
            刷新历史列表()
           else
            table.insert(读取历史[选择历史].data, {Who = "me", 内容 = 记录输入内容, 头像 = "png/me/7h.png"})
            table.insert(读取历史[选择历史].data, {Who = "ta", 内容 = json.choices[1].message.content, 头像 = "png/ta/deepseek.png"})
            io.open(历史路径,"w"):write(cjson.encode(读取历史)):close()
            刷新历史()
          end
          是否新窗口=false
        end
       else
        写入信息(数据,{Who = "ta", 内容 = "网络异常，请稍后再试\n"..code, 头像 = "png/ta/deepseek.png"})
      end
      发送.setImageBitmap(loadbitmap(activity.getLuaDir() .. "/png/3.png"))
      发送.setEnabled(true)
    end)
    编辑框.text=""
  end
end

新建对话.onClick=function(v)
  水珠动画(v,200)
  编辑框.text=""
  初始化()
  刷新历史()
  选择历史=#读取历史+1
  刷新数据()
  table.clear(对话)
  对话={}
  发送.setImageBitmap(loadbitmap(activity.getLuaDir() .. "/png/3.png"))
  发送.setEnabled(true)
end




local lb=
{
  LinearLayoutCompat;
  layout_height="wrap";
  layout_width="fill";
  orientation="vertical";
  {
    MaterialTextView;
    layout_marginTop="8dp";
    textSize="15sp";
    layout_height="wrap";
    layout_width="match_parent";
    id="日期";
    Typeface=字体1();
    textIsSelectable=true;
    ellipsize="end";
    singleLine = true,
  };
  {
    MaterialTextView;
    layout_marginTop="10dp";
    textColor="0xff000000";
    textSize="18sp";
    layout_height="wrap";
    layout_width="match_parent";
    id="标题";
    Typeface=字体1();
    ellipsize="end";
    singleLine = true,
  };
};


adp1 = LuaCustRecyclerAdapter(AdapterCreator({
  getItemCount=function()
    return #data1a
  end,
  getItemViewType=function(position)
    return 0
  end,
  onCreateViewHolder=function(parent,viewType)
    local views = {}
    layout = loadlayout(lb, views)
    local holder = LuaCustRecyclerHolder(layout)
    holder.view.setTag(views)
    return holder
  end,
  onBindViewHolder=function(holder,position)
    local view=holder.view.getTag()
    local data = data1a[position+1]
    view.标题.onClick=function()
      加载历史(position+1)
    end;
    if 是否有今天==false and judgeTimestamp(data.time)=="今天"
      view.日期.setText(judgeTimestamp(data.time))
      view.标题.setText(data.data[1].内容)
      是否有今天=true
     elseif 是否有本周==false and judgeTimestamp(data.time)=="本周"
      view.日期.setText(judgeTimestamp(data.time))
      view.标题.setText(data.data[1].内容)
      是否有本周=true
     elseif 是否有本月==false and judgeTimestamp(data.time)=="本月"
      view.日期.setText(judgeTimestamp(data.time))
      view.标题.setText(data.data[1].内容)
      是否有本月=true
     elseif 是否有本年==false and judgeTimestamp(data.time)=="本年"
      view.日期.setText(judgeTimestamp(data.time))
      view.标题.setText(data.data[1].内容)
      是否有本年=true
     else
      view.标题.setText(data.data[1].内容)
    end
  end,
}))

recy1.setAdapter(adp1).setLayoutManager(StaggeredGridLayoutManager(1, 1))

function 刷新历史列表()
  data1a={}
  table.clear(data1a)
  for k,v in ipairs(读取历史) do
    table.insert(data1a,v)
  end
  是否有今天=false
  是否有本周=false
  是否有本月=false
  是否有本年=false
  adp1.notifyDataSetChanged()
end

刷新历史列表()