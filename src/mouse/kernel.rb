#==============================================================================

# [XP/VX] 精确获取窗口句柄 by 紫苏

#==============================================================================

# ■ Kernel

#==============================================================================

module System

  #--------------------------------------------------------------------------

  # ● 需要的 Windows API 函数

  #--------------------------------------------------------------------------

  GetWindowThreadProcessId = Win32API.new("user32", "GetWindowThreadProcessId", "LP", "L")

  GetWindow = Win32API.new("user32", "GetWindow", "LL", "L")

  GetClassName = Win32API.new("user32", "GetClassName", "LPL", "L")

  GetCurrentThreadId = Win32API.new("kernel32", "GetCurrentThreadId", "V", "L")

  GetForegroundWindow = Win32API.new("user32", "GetForegroundWindow", "V", "L")

  #--------------------------------------------------------------------------

  # ● 获取窗口句柄

  #--------------------------------------------------------------------------

  def self.get_hwnd

    # 获取调用线程（RM 的主线程）的进程标识

    threadID = GetCurrentThreadId.call

    # 获取 Z 次序中最靠前的窗口

    hWnd = GetWindow.call(GetForegroundWindow.call, 0)

    # 枚举所有窗口

    while hWnd != 0

      # 如果创建该窗口的线程标识匹配本线程标识

      if threadID == GetWindowThreadProcessId.call(hWnd, 0)

        # 分配一个 11 个字节的缓冲区

        className = " " * 11

        # 获取该窗口的类名

        GetClassName.call(hWnd, className, 12)

        # 如果匹配 RGSS Player 则跳出循环

        break if className == "RGSS Player"

      end

      # 获取下一个窗口

      hWnd = GetWindow.call(hWnd, 2)

    end

    return hWnd

  end

end