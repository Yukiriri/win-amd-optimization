
#include <bits/stdc++.h>
#include <windows.h>
#include <tlhelp32.h>
#include <conio.h>
#include "PerformanceMonitor.hpp"
using std::cout;
using std::wcout;
using std::cin;
using std::string;

#define _TH_API_STYLE 0


auto GetPhysicalPCoreList()
{
    ULONG scsi_size = 0;
    GetSystemCpuSetInformation(nullptr, 0, &scsi_size, nullptr, 0);
    auto scsi_arr = (SYSTEM_CPU_SET_INFORMATION*)new uint8_t[scsi_size]{};
    GetSystemCpuSetInformation(scsi_arr, scsi_size, &scsi_size, nullptr, 0);
    
    int PCoreIndex = 0;
    for (int i = 0; i < scsi_size / sizeof(SYSTEM_CPU_SET_INFORMATION); i++)
    {
        PCoreIndex = std::max(PCoreIndex, (int)scsi_arr[i].CpuSet.EfficiencyClass);
    }
    
    std::vector<ULONG> coreList;
    for (int i = 0; i < scsi_size / sizeof(SYSTEM_CPU_SET_INFORMATION); i++)
    {
        auto scsi = scsi_arr[i];
        auto scsi_cs = scsi.CpuSet;

        if (scsi_cs.Group == 0 && scsi_cs.EfficiencyClass == PCoreIndex && scsi_cs.CoreIndex == scsi_cs.LogicalProcessorIndex)
        {
#if _TH_API_STYLE > 0
            coreList.push_back(scsi_cs.Id);
#else
            coreList.push_back(scsi_cs.CoreIndex);
#endif
        }

        std::string_view perfDesc[]{ "未识别", "未识别", "未识别" };
        switch (PCoreIndex)
        {
        case 2: perfDesc[PCoreIndex - 2] = "低功耗能效核";
        case 1: perfDesc[PCoreIndex - 1] = "能效核";
        case 0: perfDesc[PCoreIndex - 0] = "性能核";
        }
        cout << std::format("Group:{} ID:{:<3} 物理核心:{:<2} 逻辑核心:{:<2} 异构类型:{:<12} SchedulingClass:{}\n", 
            scsi_cs.Group, scsi_cs.Id, scsi_cs.CoreIndex, scsi_cs.LogicalProcessorIndex, perfDesc[scsi_cs.EfficiencyClass], scsi_cs.SchedulingClass);
    }

    delete[] scsi_arr;
    return coreList;
}

auto IsGameProcess(HWND hwnd)
{
    static PerformanceMonitor pm;
    pm.Update();

    RECT deskRect; GetWindowRect(GetDesktopWindow(), &deskRect);
    RECT wndRect; GetClientRect(hwnd, &wndRect);

    if (!(wndRect.right == deskRect.right && wndRect.bottom == deskRect.bottom))
    {
        CURSORINFO ci; GetCursorInfo(&ci);
        if (ci.flags)
            return false;
    }
    DWORD pid = 0; GetWindowThreadProcessId(hwnd, &pid);
    auto gpuUsage = pm.GetGPUUsage(pid);
    auto gpuMemMB = pm.GetGPUMemUsage(pid) >> 20;
    if (gpuUsage > 48 && gpuMemMB >= 1000)
        return true;

    return false;
}

auto SetGameMode(DWORD pid, const std::vector<ULONG>& coreList, bool isGame)
{
    auto hproc = OpenProcess(PROCESS_SET_INFORMATION | PROCESS_QUERY_INFORMATION, false, pid);
    if (hproc)
    {
#if _TH_API_STYLE > 0
        SetProcessDefaultCpuSets(hproc, coreList.data(), coreList.size());
#else
        DWORD_PTR mask = 0;
        if (isGame)
        {
            for (auto& core : coreList)
            {
                mask |= (0b01UL << core);
            }
        }
        else
        {
            DWORD_PTR tMask;
            GetProcessAffinityMask(GetCurrentProcess(), &tMask, &mask);
        }
        SetProcessAffinityMask(hproc, mask);
#endif
        SetPriorityClass(hproc, isGame ? HIGH_PRIORITY_CLASS : NORMAL_PRIORITY_CLASS);
        CloseHandle(hproc);
    }
}

auto GetPIDExeName(DWORD pid)
{
    std::wstring exeName;
    auto hsnap = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
    if (hsnap != INVALID_HANDLE_VALUE)
    {
        PROCESSENTRY32W pe32{ sizeof(pe32) };
        if (Process32FirstW(hsnap, &pe32))
        {
            do
            {
                if (pe32.th32ProcessID == pid)
                {
                    exeName = pe32.szExeFile;
                    break;
                }
            } while (Process32NextW(hsnap, &pe32));
        }
        CloseHandle(hsnap);
    }
    return exeName;
}

int main()
{
    setlocale(LC_ALL, "chs.utf8");

    auto corelist = GetPhysicalPCoreList();
    for (int i = 0; i < 50; i++) cout << "="; cout << "\n";
#if _TH_API_STYLE > 0
    cout << "已选物理性能核心ID: ";
#else
    cout << "已选物理性能核心: ";
#endif
    for (auto& cid : corelist) cout << std::format("{:<2} ", cid); cout << "\n";
    for (int i = 0; i < 50; i++) cout << "="; cout << "\n";

    for (;;Sleep(500))
    {
        if (_kbhit())
        {
            switch (_getch())
            {
                case 'h': ShowWindow(GetConsoleWindow(), SW_HIDE); break;
                case 'q': return 0;
            }
        }

        auto hwnd = GetForegroundWindow();
        if (hwnd == nullptr)
            continue;
        
        static std::map<DWORD, bool> lastGamemode;
        DWORD pid = 0; GetWindowThreadProcessId(hwnd, &pid);
        if (!lastGamemode[pid])
        {
            auto isGame = IsGameProcess(hwnd);
            if (isGame)
            {
                lastGamemode[pid] = isGame;
                SetGameMode(pid, corelist, isGame);

                WCHAR wndTitle[50]{};
                GetWindowTextW(hwnd, wndTitle, sizeof(wndTitle) / 2);
                wcout << std::format(L"SetGameMode:{:<5} pid={:<5} [{}] [{}]\n", isGame, pid, GetPIDExeName(pid), wndTitle);
            }
        }
    }

    return 0;
}
