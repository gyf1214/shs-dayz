demand 'src/mouse/kernel.rb'

#==============================================================================

# ** Mouse Input Module (Revised) 

#------------------------------------------------------------------------------

#   by DerVVulfman

#   version 1.2

#   08-18-2007

#------------------------------------------------------------------------------

#   Based on...

#   Mouse Input Module

#   by Near Fantastica

#------------------------------------------------------------------------------

#   Set_Pos feature by

#   Freakboy

#------------------------------------------------------------------------------

#

#   THE CALLS: 

#

#   Mouse.click?

#   This returns a true/false value  when you test whether a button is clicked.

#   The values you pass are 1 (for the left mouse button), 2 (for the right) or

#   3 (for the middle button).

#

#   Mouse.press?

#   This returns a true/false value  when you test  whether a button is pressed

#   and kept depressed.  The values you pass are 1 (for the left mouse button),

#   2 (for the right mouse button), or 3 (for the middle).

#

#   Mouse.pixels

#   This returns the  mouse's screen coordinates  in pixels.  Based on a screen

#   with a 640x480 dimension,  this returns an array of the mouse's position in

#   index values.  Calling Mouse.pixels returns both x & y positions  in a sin-

#   gle string,  but calling Mouse.pixels[0] returns the x position (0-639) and

#   calling Mouse.pixels[1]  returns  the y position (0-439).   If the mouse is

#   outside of the game's window region, this call returns nil.

#

#   Mouse.tiles

#   This returns  the mouse's screen  coordinates  in map tiles.   Based on the

#   system's 20x15 tile size,  this returns it in index values  (a 0-19 width & 

#   a 0-14 height).  This functions the same manner as Mouse.pixels.

#

#   Mouse.set_pos

#   This allows you  to forcefully position the mouse at an x/y position within

#   the game screen by pixel coordinates.  Given the game's normal screen width

#   of 640x480, adding:  Mouse.set_pos(320,240)  should position the mouse dead

#   center of the gaming window.

#

#   Mouse.update

#   Add this routine  into your update routines  to update  the mouse position.

#   It must be called otherwise you won't get valid mouse coordinates.

#==============================================================================



module Mouse

  #--------------------------------------------------------------------------

  # * Mouse in_area

  #--------------------------------------------------------------------------

  def Mouse.area?(x, y, width=32, height=32)

    return false if @pos == nil

    return true if @pos[0] >= x and @pos[0] <= (x+width) and @pos[1] >= y and @pos[1] <= (y+height)

    return false

  end

  #--------------------------------------------------------------------------

  # * Mouse Pixel Position

  #--------------------------------------------------------------------------

  def Mouse.pixels

    return @pos == nil ? [0, 0] : @pos

  end

  #--------------------------------------------------------------------------

  # * Mouse Tile Position

  #--------------------------------------------------------------------------

  def Mouse.tiles

    return nil if @pos == nil

    x = @pos[0] / 32

    y = @pos[1] / 32

    return [x, y]

  end

  #--------------------------------------------------------------------------

  # * Mouse Update

  #--------------------------------------------------------------------------

  def Mouse.update

    @pos = Mouse.pos

    ## 清空

    @press,@toggled = 0,0

    ## 状态记录

    @press += LKEY   if GetKeyState.call(LKEY) & 0x8000 > 0

    @press += RKEY   if GetKeyState.call(RKEY) & 0x8000 > 0

    @press += MKEY   if GetKeyState.call(MKEY) & 0x8000 > 0

    ## 触发记录

    @toggled += LKEY if GetKeyState.call(LKEY) & 0x01 > 0

    @toggled += RKEY if GetKeyState.call(RKEY) & 0x01 > 0

    @toggled += MKEY if GetKeyState.call(MKEY) & 0x01 > 0

    ## 单击记录

    @clicks.shift if @clicks.size >=2

    @clicks.push @press

    ## 双击记录

    if @dblc.size >= 2

      @dblc.clear

      @count = 0

    end

    if @dblc.size == 1 and @count - @dblc[0][1] > DBLCTIME

      @dblc.clear

      @count = 0

    end

    if @clicks[0] == 0 and @clicks[1] != 0

      if @dblc.size == 1 and @dblc[0][0] != @clicks[1]

        @dblc.clear

        @count = 0

      end

      @dblc.push [@press,@count,@pos]

    end

    @count += 1 unless @dblc.empty?

    ## 移动记录

    @move_pos.shift if @move_pos.size >= 2

    @move_pos.push @pos

    ## 控制鼠标单击效果

    $click_abled = true

  end 

  #--------------------------------------------------------------------------

  # * Automatic functions below 

  #--------------------------------------------------------------------------

  #

  #--------------------------------------------------------------------------

  # * Obtain Mouse position in screen

  #--------------------------------------------------------------------------

  def Mouse.global_pos

    pos = [0, 0].pack('ll')

    ## 屏幕坐标

    return GetCursorPos.call(pos) != 0 ? pos.unpack('ll') : nil

  end

  #--------------------------------------------------------------------------

  # * Return Screen mouse position within game window

  #--------------------------------------------------------------------------

  def Mouse.pos

    x, y = Mouse.screen_to_client(*Mouse.global_pos)

    width, height = Mouse.client_size

    begin

      if (x >= 0 and y >= 0 and x < width and y < height)

        return x, y

      else

        return nil

      end

    rescue

      return nil

    end

  end

  #--------------------------------------------------------------------------

  #  * Pass Screen to Game System

  #--------------------------------------------------------------------------

  def Mouse.screen_to_client(x, y)

    return nil unless x and y

    pos = [x, y].pack('ll')

    if ScreenToClient.call(HWND, pos) != 0

      return pos.unpack('ll')

    else

      return nil

    end

  end

  #--------------------------------------------------------------------------

  # * Get Game Window Size

  #--------------------------------------------------------------------------

  def Mouse.client_size

    rect = [0, 0, 0, 0].pack('l4')

    GetClientRect.call(HWND, rect)

    right, bottom = rect.unpack('l4')[2..3]

    return right, bottom

  end

  #--------------------------------------------------------------------------

  # * Get Window Position

  #--------------------------------------------------------------------------

  def Mouse.client_pos

    rect = [0, 0, 0, 0].pack('l4')

    GetWindowRect.call(HWND, rect)

    left, upper = rect.unpack('l4')[0..1]

    return left+4, upper+30

  end

  #--------------------------------------------------------------------------

  # ## 设定鼠标坐标

  #-------------------------------------------------------------------------- 

  def self.set_pos(x = 0, y = 0)

    width, height = Mouse.client_size

    if (x.between?(0, width) && y.between?(0, height))

      px = Mouse.client_pos[0] + x

      py = Mouse.client_pos[1] + y

      Win32API.new('user32', 'SetCursorPos', 'ii', 'l').call(px, py)

    end

  end

  #--------------------------------------------------------------------------

  # ## 触发?

  #--------------------------------------------------------------------------

  def self.toggled?(key)

    return @toggled & key != 0

  end

  #--------------------------------------------------------------------------

  # ## 按下?

  #--------------------------------------------------------------------------

  def Mouse.press?(key)

    return @press & key != 0

  end

  #--------------------------------------------------------------------------

  # ## 单击?

  #--------------------------------------------------------------------------

  def self.click?(key)

    return false if key == LKEY and !$click_abled

    return @clicks[0] & key == 0 && @clicks[1] & key != 0

  end

  #--------------------------------------------------------------------------

  # ## 双击?

  #--------------------------------------------------------------------------

  def self.dbl_click?(key)

    return false if @dblc.size < 2

    ## 键值有效

    if @dblc[1][0] & key != 0 and @dblc[0][0] & key != 0

      ## 间隔有效

      if @dblc[1][1] - @dblc[0][1] < DBLCTIME

        ## 坐标有效

        if @dblc[1][2] == @dblc[0][2]

          return @clicks[0] & key == 0 && @clicks[1] & key != 0

        end

      end

    end

    return false

  end

  #--------------------------------------------------------------------------

  # ## 经过?

  #     obj       : 对象实例

  #                 **支持Sprite,Window,Viewport,Rect,Plane,可补充

  #--------------------------------------------------------------------------

  def Mouse.over?(obj)

    case obj

    when Sprite

      x = obj.x-obj.ox; y = obj.y-obj.oy

      unless obj.viewport.nil?

        x += obj.viewport.rect.x

        y += obj.viewport.rect.y

      end

      return Mouse.area?(x, y, obj.width, obj.height)

    when Window

      x = obj.x;y = obj.y

      unless obj.viewport.nil?

        x += obj.viewport.rect.x

        y += obj.viewport.rect.y

      end

      return Mouse.area?(x, y, obj.width, obj.height)

    when Viewport

      return Mouse.area?(obj.rect.x, obj.rect.y, obj.rect.width, obj.rect.height)

    when Rect

      return Mouse.area?(obj.x, obj.y, obj.width, obj.height)

    when Plane

      x = obj.x;y = obj.y

      unless obj.viewport.nil?

        x += obj.viewport.rect.x

        y += obj.viewport.rect.y

      end

      return Mouse.area?(x, y, obj.width, obj.height)

    end

  end

  #--------------------------------------------------------------------------

  # ## 移动?

  #--------------------------------------------------------------------------

  def self.move?

    return false if @move_pos.size < 2

    return @move_pos[1] != @move_pos[0]

  end

  #--------------------------------------------------------------------------

  # ## 滚轮

  #--------------------------------------------------------------------------

  def self.scroll

    msg = "\0"*32

    PeekMessage.call(msg,0,0,0,PM_NOREMOVE)

    r = unpack_msg(msg)

    return unless r[0] == WM_MOUSEWHEEL

    return word2signed_short(hiword(r[1]))

  end

  #--------------------------------------------------------------------------

  # ## 窗体信息

  #--------------------------------------------------------------------------

  def self.unpack_msg(buffer)

    msg = []

    msg << unpack_dword(buffer, 4*1)

    msg << unpack_dword(buffer, 4*2)

    return msg

  end

  #--------------------------------------------------------------------------

  # ## 转带符号整型

  #--------------------------------------------------------------------------

  def self.word2signed_short(value)

    return value if (value & 0x8000)==0

    return -1*((~value&0x7fff) + 1)

  end

  #--------------------------------------------------------------------------

  # ## 低位

  #--------------------------------------------------------------------------

  def self.loword(dword)

    return dword & 0x0000ffff

  end

  #--------------------------------------------------------------------------

  # ## 高位

  #--------------------------------------------------------------------------

  def self.hiword(dword)

    return (dword & 0xffff0000) / 0x10000

  end

  #--------------------------------------------------------------------------

  # ## 双字节

  #--------------------------------------------------------------------------

  def self.unpack_dword(buffer, offset=0)

    ret=buffer[offset+0]&0x000000ff

    ret|=(buffer[offset+1]<<(8*1)) & 0x0000ff00

    ret|=(buffer[offset+2]<<(8*2)) & 0x00ff0000

    ret|=(buffer[offset+3]<<(8*3)) & 0xff000000

    return ret

  end

  #--------------------------------------------------------------------------

  # ## 常量

  #--------------------------------------------------------------------------

  GetKeyState      = Win32API.new('user32','GetKeyState',['i'],'i')

  ScreenToClient   = Win32API.new('user32', 'ScreenToClient', 'lp', 'i')

  GetCursorPos     = Win32API.new('user32', 'GetCursorPos', 'p', 'i')

  GetWindowRect    = Win32API.new('user32', 'GetWindowRect', 'lp', 'i')

  GetClientRect    = Win32API.new('user32', 'GetClientRect', 'lp', 'i')

  GetDblClickTime  = Win32API.new('user32','GetDoubleClickTime','','l')

  PeekMessage      = Win32API.new('user32','PeekMessage','pllll','l')

  

  WM_MOUSEWHEEL    = 0x20A

  PM_NOREMOVE      = 0x0

  

  HWND             = System.get_hwnd

  LKEY,RKEY,MKEY   = 1,2,4

  DBLCTIME         = (GetDblClickTime.call * 60.0 / 1000).round

  #--------------------------------------------------------------------------

  # ## 内部变量

  #--------------------------------------------------------------------------

  @count    = 0     ## 双击时间计数

  @dblc     = []    ## 双击记录[key,wait,[mouse_x,mouse_y]]

  @move_pos = []    ## 移动记录

  @clicks   = []    ## 单击记录

end