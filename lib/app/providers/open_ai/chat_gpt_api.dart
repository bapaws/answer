// import 'package:flutter_chatgpt_api/flutter_chatgpt_api.dart';
//
// // https://github.com/Chanzhaoyu/chatgpt-web/issues/425
// // ChatGPTUnofficialProxyAPI no longer works – use ChatGPTAPI instead
// class ChatGptApi extends ServiceProvider {
//   late final _api = ChatGPTApi(
//     sessionToken: tokens.first.value,
//     clearanceToken: tokens.lastOrNull?.value ?? '',
//     userAgent:
//         'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36',
//   );
//
//   String? _conversationId;
//   String? _parentMessageId;
//
//   ChatGptApi({
//     super.onReceived,
//   }) : super(
//           id: 'chat_gpt_api',
//           name: 'Chat GPT Secret API',
//           avatar: 'assets/images/open_ai_chat_gpt.svg',
//           officialUrl: 'https://www.bapaws.com/chat/completions',
//           apiUrl: 'https://chat.openai.com/chat',
//           groupId: 0,
//           help: '',
//           helpUrl: '',
//           welcome: '',
//           hello: '',
//           tokens: [
//             ServiceToken(
//               id: 'chat_gpt_api_session_token',
//               name: 'Session Token',
//               value:
//                   'eyJhbGciOiJkaXIiLCJlbmMiOiJBMjU2R0NNIn0..EeRR9pb9Zm4SJPav.8h_rvJ88PzWTw54ufFNegi-eSaFHyaYeH90McGAkaNgeJPXOqT6U0RAedkSw1DKjXWLCWmqA7rKVf_0FjirYF7ji7aHdhKw5b8jl3bYJhHGtGSp872nUTLu6MsLWvFODV0wpeS46N3LKEbi87btOG2cBxUyEs1cIGh60BclFUrBvyh2Y31W7Ixhq89CWBkONsQcZ3OmwszEcU0CDcN5VaY2iK8WwFDLxSLr6tY6iSmWm_G_soCHtCHB2_TU7H3OCQjdSrsiMgr1XzUrz9SSHqs-7LoyVL55SzfMm9ZzvU3nEHf9_4xMfCyarkaE2EU1W39EwETV66EdBPKLfpD-Wb5NZiDNvUUmo7d7KjY5g6woVXFtnyU7lv1hO8lNx--hIn8viAWmOdeWt37Ly3yWxUPQg6TTMD_qL6PHP-bEI4REp_DzoTUQKYdua_Mz_zKPm0rOKmSdfLtSWuEFEWDNKKOXf7rq9ksr6XmCigOb5FhERZ_1VRmMEwedVV0zjd6x9e0u1jr0fq7_TraWra-jWv2Q7TR8UcKNRfhWoLNf2-M9ZUhQRe3oNF4o0D95ZUIi4Np32JShRfleeJFmll2ldP_5kGsWcf1jWL-fwYLaIrVscrBT_ao3_FnGuBHbOx6I-YVaGpdFp1ZAOWyVJUxOVJomX-ClE80tIfZZ4ZpqPIjP_sUGKEmCWX_SkKL0_7uq8zzXplb1Xo9ADdrx9C9GynuTSkTKe-2-dri5pK2bbT0NCPiPE3mH3nztHVqerkOrxN2TXb8mGksrxHcrSq4aSGPOVtf64ScGwQDtFZtLYmXyVNpypMqUorsPhGKvpcG7oMMUsfKKQlp_8d1Nkr3pSJa7h9dQMPzMn4AJuvwVWNLRiryZhocz5VkXO8AYehTD78mD3TXn3DKyQyVlhUgTLB290w2iCoxiuYZlGIfFJGTomnscnNss8Eu_qFaAQ-82KRmwAA-IhhOBY6Vv2sU9elfpEGsDIa8TO72FgQiXb1ZV_FzDmNTnXyfcF5qwG0Z8S0ID5lAGHNa1-tDOIFdtQQG82UtHzPjnfqqJa8PIX-RycZODr2L5cD6ixUZTjvj_IsCzZmey6Ny3ISnsAvggtol8Z1Xh0u7_MHmWyHcEOaNSf2KaYVz84N8JxCdgX5zuoJ5Ya6WHqcGK0Ak3PzRh29hPGpKr4oLzB1Y_IgV_X2xfSmWoT-VA2nlBrdyGDeq7vtEEnLifznj8CtIUJVyBWPTc5jPtO-ouxdEkN9sKrwk5wV1h3Hq64zdjmlYGxvrWPjWZP3PZ6XPMe4GcAHRKPTuBLwFqiQozya6BMdxHjJ2ATfuxfOkiZiVK5nD2Z9Em8rMdlPTSZqqV1uv7qRU7SPhAQyyBMU-GgohClSUPSBT1mXez-BgbXzx9wjgu0dUk0KFaJg1bwucDXm5O0PPN58pNrN3eFRez3KfM9zAvaSE9yVLyLZbnNn9WPDbgZdo04svuppwgI7nK9jJMVaITJCLvtKMfjK6G6T9JCUmMfLLnz5ePGYLI1DHe5R5xfjTunlVu-WiDWKs-xiDJmL4CeFJ_6mtukyb4v6LWWJpps8kUiAjYnBOVR4_uPATyRg9RH2bu0ZHKZn7-z2L9EE_JZ8Z8B-DHT2hVvVjp44yJT2i50Qw-hDhw1RE2wsDniaVtrNbmRlc_Orzqx13QU5YyNp949zJaxRjMz0-61keXsT1PIF563eYgkfudId_knBu-i9qYEBLgDq6HWgE8-YTbNdutpHUCR9NHVFjqJqbdi7lZLF8MVzZ7ykOIaBROiG_XOwPvPpZ3C9v3F7qU5mkiiX0Ohj5ZZjlv9jaOk60mT7QtPAYMUm8o4K6YlQ0Gqh-5VNgk2tr3ovDZopaOUNbRtTvYrsu43W0q1wuRHFdPf7P7se6ROtUlfp-MBkXU7s4NAjaDRJ-jfnnV7isLjGq7gxom1HN0kvbqJyJgM_fZySOfTw6-Hk2Re0F12hXK2AtsJ4mdqBZIcTyyrQ6JZOOHfj24EBHBYm1OLKX82U6hmJmhN8lfJrzZPfNPz_3nzdytsNKHifGPt1jsmj7Oq5ZyiGBRO2cPyTdvljzr27Bjym3pKKxs7_C0pOhCELlP551k1oojRbBI_FB7oscIsL8zXRpm0eJmZmsGn1ChgToaBJ6fDk5DZE5vjUbPCiZ-k8s18AXq2mGxgpMv3i2_KoXxNMQ4BMfkTrAKUSVy5xLRxydmIGFKyTp_j9TjhhSkX-v7v3yHVmZk_Ek4CrR1GpYyCU-wagI9PJqMvN621jSRFp7V7xa02Tu6KBVXAgiX-67uVjt8TG-ip9o11IPgPHmGQ3Klv164J25QL-I7VSSN7DZW5WfDbwv3a9KGnKFgxrksHefhakks8PQ85kw5sGCZvQXQDjG2eYZ_u1JG2eX87HfV-JpGVLtWDV8R9_6dnLvHkOI_8xVhdxgaU34V0YFVOpiDdzi9CgLsx.KYZAvYmXggxyUnE06fo8nQ',
//               serviceProviderId: 'chat_gpt_api',
//             ),
//             ServiceToken(
//               id: 'chat_gpt_api_cf_clearance',
//               name: 'Clearance Token',
//               value:
//                   '6cdHtbWyNVs2jVGZlt83DchpJJxWIe68D9zVVKeTV.4-1678453704-0-1-4d2bf02a.d1b88486.1a2aafca-160',
//               serviceProviderId: 'chat_gpt_api',
//             ),
//           ],
//         );
//
//   @override
//   Future<void> send({required Message message}) async {
//     super.send(message: message);
//     // Future.delayed(const Duration(seconds: 3), () {
//     //   receiveErrorMessage(message,
//     //       '失败了，失败嘞\n失败了，失败嘞失败了，失败嘞失败了，失败嘞失败了，失败嘞失败了，失败嘞失败了，失败嘞失败了，失败嘞失败了，失败嘞失败了，失败嘞失败了，失败嘞失败了，失败嘞失败了，失败嘞失败了，失败嘞\n失败了');
//     // });
//
//     try {
//       var newMessage = await _api.sendMessage(
//         message.content!,
//         conversationId: _conversationId,
//         parentMessageId: _parentMessageId,
//       );
//       _conversationId = newMessage.conversationId;
//       _parentMessageId = newMessage.messageId;
//
//       receiveTextMessage(
//         requestMessage: message,
//         content: newMessage.message,
//       );
//     } catch (e) {
//       receiveErrorMessage(message, e);
//     }
//   }
// }
