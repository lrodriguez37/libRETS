%module librets

%{
#include "librets.h"
using namespace librets;
using std::vector;
using std::string;
%}

#ifndef SWIGXML
%include "std_string.i"
%include "std_vector.i"
#endif
%include "exception.i"
%include "auto_ptr_release.i"

%template(StringVector) std::vector<std::string>;

%exception {
    try {
        $action
    } catch(std::exception & e) {
        std::string message = std::string(e.what()) + "\n";
        SWIG_exception(SWIG_ValueError, message.c_str());
    } catch(...) {
        SWIG_exception(SWIG_RuntimeError,"Unknown exception\n");
    }
}

%nodefault RetsException;
class RetsException
{
  public:
    virtual std::string GetMessage();
};

class SearchRequest
{
  public:
    SearchRequest(std::string searchType, std::string searchClass,
                  std::string query);
    
    void SetStandardNames(bool standardNames);

    void SetSelect(std::string select);
    
    static const int LIMIT_DEFAULT = -1;
    static const int LIMIT_NONE = 0;
    void SetLimit(int limit);
    
    static const int OFFSET_NONE = 0;
    void SetOffset(int offset);
    
    enum CountType
    {
        NO_RECORD_COUNT,
        RECORD_COUNT_AND_RESULTS,
        RECORD_COUNT_ONLY
    };

    void SetCountType(CountType countType);
};
typedef std::auto_ptr<SearchRequest> SearchRequestAPtr;

class SearchResultSet
{
  public:
    bool HasNext();
    
    int GetCount();
    
    const std::vector<std::string> GetColumns();
    
    std::string GetString(int columnIndex);
    
    std::string GetString(std::string columnName);
};
typedef std::auto_ptr<SearchResultSet> SearchResultSetAPtr;

class LogoutResponse
{
  public:
    std::string GetBillingInfo();
    std::string GetLogoutMessage();
    int GetConnectTime();
};
typedef std::auto_ptr<LogoutResponse> LogoutResponseAPtr;


SWIG_AUTO_PTR_RELEASE(SearchRequest);
SWIG_AUTO_PTR_RELEASE(SearchResultSet);
SWIG_AUTO_PTR_RELEASE(LogoutResponse);

/****************************************************************************
 * Metadata
 ***************************************************************************/
 
class MetadataSystem
{
  public:
    std::string GetSystemID() const;  
    
    std::string GetSystemDescription() const;
    
    std::string GetComments() const;
};

class MetadataResource
{
  public:
    std::string GetId() const;
    
    std::string GetResourceID() const;
    
    std::string GetStandardName() const;
};

// typedef std::vector<MetadataResource *> MetadataResourceList;
// %template(MetadataResourceList) std::vector<MetadataResource *>;

%nodefault;

class RetsMetadata
{
  public:
    MetadataSystem * GetSystem() const;
//    std::vector<MetadataResource *> GetAllResources() const;
};

%default;
 
/****************************************************************************
 * RetsSession
 ***************************************************************************/

enum RetsVersion
{
    RETS_1_0,
    RETS_1_5
};

class RetsSession
{
  public:
    RetsSession(std::string loginUrl);

    bool Login(std::string userName, std::string password);

    std::string GetAction();

    SearchRequestAPtr CreateSearchRequest(std::string searchType, 
                                          std::string searchClass,
                                          std::string query);

    SearchResultSetAPtr Search(SearchRequest * request);
    
    LogoutResponseAPtr Logout();
    
    RetsMetadata * GetMetadata();
    
    bool IsIncrementalMetadata() const;
    
    void SetIncrementalMetadata(bool incrementalMetadata);

    
    void SetUserAgent(std::string userAgent);

    void UseHttpGet(bool useHttpGet);
    
    void SetRetsVersion(RetsVersion retsVersion);
    
    RetsVersion GetRetsVersion() const;
    
    RetsVersion GetDetectedRetsVersion() const;
};


/* Local Variables: */
/* mode: c++ */
/* End: */
