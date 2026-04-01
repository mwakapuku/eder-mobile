# eder


### Flow summary
```
CreateReportScreen
  → _submitReport()
      → reportSubmitProvider.submitReport(report)   // POST /reports/
          → server returns { data: { id: 42, ... } }
      → Navigator.pushNamed('/upload-images', { reportId: 42 })

UploadImagesScreen
  → _submit(reportId: 42)
      → reportSubmitProvider.uploadImages(reportId, images)  // POST /reports/images/ (multipart)
      → on success → reset provider → navigate to /home
samples, guidance on mobile development, and a full API reference.
