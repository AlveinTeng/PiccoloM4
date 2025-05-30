# 构建流程梳理
首先先从顶层的`CMakeLists.txt`文件开始看起，顶层的`CMakeLists.txt`文件会包含所有子目录的`CMakeLists.txt`文件。
## 1. 顶层CMakeLists.txt
顶层CMakeLists.txt文件,在Piccolo/下，主要包含了以下几个部分：
1. 设置CMake的最小版本和项目名称:
    ```cmake
    cmake_minimum_required(VERSION 3.19 FATAL_ERROR)

    project(Piccolo VERSION 0.1.0)
    ```
2. 设置C++标准和一些变量:
    ```cmake
    set(CMAKE_CXX_STANDARD 17)
    set(CMAKE_CXX_STANDARD_REQUIRED ON)
    set(BUILD_SHARED_LIBS OFF)

    include(CMakeDependentOption)

    if(PROJECT_SOURCE_DIR STREQUAL PROJECT_BINARY_DIR)
        message(
            FATAL_ERROR
            "In-source builds not allowed. Please make a new directory (called a build directory) and run CMake from there."
        )
    endif()

    set(PICCOLO_ROOT_DIR "${CMAKE_CURRENT_SOURCE_DIR}")
    set(CMAKE_INSTALL_PREFIX "${PICCOLO_ROOT_DIR}/bin")
    set(BINARY_ROOT_DIR "${CMAKE_INSTALL_PREFIX}/")
    ``` 
3. 添加子目录:
    ```cmake
    add_subdirectory(engine)
    ```
总结一下，其实顶层CMakeLists.txt文件主要是设置一些全局的变量和选项，然后添加子目录。这里的子目录就是`engine`，它包含了Piccolo的核心引擎代码。接下来为了梳理清楚整个构建流程，我们需要深入到`engine`目录下的`CMakeLists.txt`文件中去看。

## 2. engine目录下的CMakeLists.txt
在`engine`目录下的`CMakeLists.txt`文件中，和顶层的`CMakeLists.txt`大同小异，主要包含了以下几个部分：
- 配置路径与变量
- 平台相关的配置
- 添加子目录, 其中包括三方库、着色器模块，以及主功能模块等
其实从这里，我们就可以联系到之前104课程中讲到的引擎是一个分层架构了
- 代码生成模块以及依赖关系的配置

这里我们只需重点关注依赖关系的配置部分
```cmake
# 添加依赖关系
add_dependencies(PiccoloRuntime "${CODEGEN_TARGET}")
add_dependencies("${CODEGEN_TARGET}" "PiccoloParser")
```
这里不妨深入想一下，为什么会有这样的依赖关系，其实是和引擎的反射系统有关。因为反射系统需要在运行时动态地访问和修改对象的属性和行为，而这就需要在编译时就确定好相关的依赖关系，以便在生成代码时能够正确地引用和使用这些对象。

### 后续子模块
大同小异，这里不过多探究。
