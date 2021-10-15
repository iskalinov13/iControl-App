////
////  ProductImageService.swift
////  iControlApp
////
////  Created by Farukh Iskalinov on 6.05.21.
////
//
//import Alamofire
//import AlamofireImage
//
//protocol ProductImageService {
//    func uploadImage(imageData: Data, success: @escaping (ImageUploadResponse) -> Void, failure: @escaping () -> Void)
//}
//
//class ProductImageServiceImpl: ProductImageService {
//    private let host = "http://172.20.10.2:8000"
//    
//    func uploadImage(imageData: Data, success: @escaping (ImageUploadResponse) -> Void, failure: @escaping () -> Void) {
////        let request = requestProvider.createUploadImageRequest(imageData: imageData)
////        let params: [String: Any] = [
////            "scope": Constants.mediaImagesScope,
////            "resize": "XS,S,M,L",
////            "quality": Constants.mediaImageQuality,
////            "webp": true,
////            "webp_quality": Constants.mediaWebQuality
////        ]
//        guard
//            let access = CurrentUser.access,
//            let userId = CurrentUser.id
//        else {
//            return
//        }
//        
//        guard let url = URL(string: "\(host)/api/update_user_info/\(userId)/") else { return }
//        print(url)
//        let header: HTTPHeaders = [
//            "Authorization": "Bearer \(access)"
//        ]
//        print("Bearer \(String(describing: CurrentUser.access))")
//        AF.upload(
//            multipartFormData: { multipartFormData in
//                multipartFormData.append(
//                    imageData,
//                    withName: "image1",
//                    fileName: "\(UUID().uuidString.lowercased()).jpeg",
//                    mimeType: "image/jpeg"
//                )
////                for (key, value) in params {
////                    if let value = "\(value)".data(using: String.Encoding.utf8) {
////                        multipartFormData.append(value, withName: key)
////                    }
////                }
//            },
////            to: url) { result in
////                switch result {
////                case .success(let upload, _):
////                    upload.responseJSON(
////                        completionHandler: { response in
////                            if
////                                let data = response.data,
////                                let value = try? JSONDecoder().decode(ImageUploadResponse.self, from: data) {
////                                success(value)
////                            } else {
////                                failure()
////                            }
////                        }
////                    )
////                case .failure(let error):
////                    debugPrint(error)
////                    failure()
////                }
////            }
//    //}
//
//}
