#pragma once
#include <bits/stdc++.h>
#include <pdh.h>
#include <pdhmsg.h>


class PerformanceMonitor
{
public:
    decltype(PdhOpenQueryA)*                _dll_PdhOpenQueryA = nullptr;
    decltype(PdhCloseQuery)*                _dll_PdhCloseQuery = nullptr;
    decltype(PdhAddCounterA)*               _dll_PdhAddCounterA = nullptr;
    decltype(PdhRemoveCounter)*             _dll_PdhRemoveCounter = nullptr;
    decltype(PdhCollectQueryData)*          _dll_PdhCollectQueryData = nullptr;
    decltype(PdhGetFormattedCounterValue)*  _dll_PdhGetFormattedCounterValue = nullptr;
    decltype(PdhGetFormattedCounterArrayA)* _dll_PdhGetFormattedCounterArrayA = nullptr;

    PerformanceMonitor()
    {
        #define _PM_DLLIMP(hdll, apiName) _dll_##apiName = (decltype(_dll_##apiName))GetProcAddress(hdll, #apiName)
        #define _PM_ASSERT(exp) if (!(exp)) return -1
        _PM_DLLIMP(_hpdhdll, PdhOpenQueryA);
        _PM_DLLIMP(_hpdhdll, PdhCloseQuery);
        _PM_DLLIMP(_hpdhdll, PdhAddCounterA);
        _PM_DLLIMP(_hpdhdll, PdhRemoveCounter);
        _PM_DLLIMP(_hpdhdll, PdhCollectQueryData);
        _PM_DLLIMP(_hpdhdll, PdhGetFormattedCounterValue);
        _PM_DLLIMP(_hpdhdll, PdhGetFormattedCounterArrayA);

        _dll_PdhOpenQueryA(nullptr, 0, &_hquery);
    }
    ~PerformanceMonitor()
    {
        _dll_PdhCloseQuery(_hquery);
        FreeLibrary(_hpdhdll);
    }

    auto Update()
    {
        auto t = std::chrono::steady_clock::now();
        static auto last_t = t - std::chrono::milliseconds(500);
        if (t - last_t >= std::chrono::milliseconds(500))
        {
            auto ret = _dll_PdhCollectQueryData(_hquery);
            if (ret != ERROR_SUCCESS && ret == PDH_INVALID_HANDLE)
                return FALSE;
            last_t = t;
        }
        return TRUE;
    }

    double GetCPUUsage(std::string_view processorID)
    {
        auto counterName = std::format("\\Processor({})\\% Processor Time", processorID);
        auto hcounter = GetCounter(counterName);

        PDH_FMT_COUNTERVALUE counterValue;
        _PM_ASSERT(_dll_PdhGetFormattedCounterValue(hcounter, PDH_FMT_DOUBLE, nullptr, &counterValue) == ERROR_SUCCESS);

        return counterValue.doubleValue;
    }

    auto GetCPUUsage(int processorID)
    {
        return GetCPUUsage(std::to_string(processorID));
    }

    auto GetAllCPUUsage()
    {
        return GetCPUUsage("_Total");
    }

    double GetGPUUsage(DWORD pid, std::string_view unitName)
    {
        auto counterName = std::format("\\GPU Engine(*)\\Utilization Percentage", pid);
        auto hcounter = GetCounter(counterName);

        DWORD arr_size = 0, arr_count;
        _PM_ASSERT(_dll_PdhGetFormattedCounterArrayA(hcounter, PDH_FMT_DOUBLE, &arr_size, &arr_count, nullptr) == PDH_MORE_DATA);
        auto items = (PDH_FMT_COUNTERVALUE_ITEM_A*)new uint8_t[arr_size]{};
        _PM_ASSERT(_dll_PdhGetFormattedCounterArrayA(hcounter, PDH_FMT_DOUBLE, &arr_size, &arr_count, items) == ERROR_SUCCESS);
        auto usage = 0.0;
        for (int i = 0; i < arr_count; i++)
        {
            auto subCounterName = std::string_view(items[i].szName);
            if (pid && !subCounterName.contains(std::format("pid_{}", pid)))
                continue;
            if (unitName.length() && !subCounterName.contains(unitName))
                continue;
            usage += items[i].FmtValue.doubleValue;
        }

        delete[] items;
        return usage;
    }

    auto GetGPUUsage(DWORD pid)
    {
        return std::max(GetGPUUsage(pid, "engtype_3D"), GetGPUUsage(pid, "engtype_Graphics_"));
    }

    auto GetAllGPUUsage(std::string_view unitName)
    {
        return GetGPUUsage(0, unitName);
    }

    auto GetAllGPUUsage()
    {
        return std::max(GetAllGPUUsage("engtype_3D"), GetAllGPUUsage("engtype_Graphics_"));
    }

    int64_t GetGPUMemUsage(DWORD pid, std::string_view unitName)
    {
        auto counterName = std::format("\\GPU Process Memory(*)\\{}", unitName);
        auto hcounter = GetCounter(counterName);

        DWORD arr_size = 0, arr_count;
        _PM_ASSERT(_dll_PdhGetFormattedCounterArrayA(hcounter, PDH_FMT_LARGE, &arr_size, &arr_count, nullptr) == PDH_MORE_DATA);
        auto items = (PDH_FMT_COUNTERVALUE_ITEM_A*)new uint8_t[arr_size]{};
        _PM_ASSERT(_dll_PdhGetFormattedCounterArrayA(hcounter, PDH_FMT_LARGE, &arr_size, &arr_count, items) == ERROR_SUCCESS);
        auto usage = 0LL;
        for (int i = 0; i < arr_count; i++)
        {
            auto subCounterName = std::string_view(items[i].szName);
            if (pid && !subCounterName.contains(std::format("pid_{}", pid)))
                continue;
            usage += items[i].FmtValue.largeValue;
        }

        delete[] items;
        return usage;
    }

    auto GetGPUMemUsage(DWORD pid)
    {
        return GetGPUMemUsage(pid, "Local Usage");
    }

    auto GetAllGPUMemUsage(std::string_view unitName)
    {
        return GetGPUMemUsage(0, unitName);
    }

    auto GetAllGPUMemUsage()
    {
        return GetAllGPUMemUsage("Local Usage");
    }

    HCOUNTER GetCounter(std::string_view counterName)
    {
        auto hcounter = _counterList[counterName.data()];
        if (hcounter == nullptr)
        {
            if (_dll_PdhAddCounterA(_hquery, counterName.data(), 0, &hcounter) != ERROR_SUCCESS)
                return nullptr;
            _counterList[counterName.data()] = hcounter;
            //Sleep(500);
        }
        return hcounter;
    }

private:
    HMODULE _hpdhdll = LoadLibraryA("pdh.dll");
    HQUERY _hquery = nullptr;
    std::map<std::string, HCOUNTER> _counterList;
};
