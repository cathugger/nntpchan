#ifndef NNTPCHAN_FILE_HANDLE_HPP
#define NNTPCHAN_FILE_HANDLE_HPP

#include <memory>
#include <fstream>
#include <experimental/filesystem>

namespace nntpchan
{
  typedef std::unique_ptr<std::fstream> FileHandle_ptr;

  enum FileMode
  {
    eRead,
    eWrite
  };

  namespace fs = std::experimental::filesystem;
  
  FileHandle_ptr OpenFile(const fs::path & fname, FileMode mode);
}

#endif
