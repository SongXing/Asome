//
//  YCPPPView.m
//  YCSDK
//
//  Created by sunn on 2018/7/11.
//

#import "YCPPPView.h"
#import "HelloHeader.h"

#define kGoodsNameAndPriceViewHeight    40.0f
#define kHulalaFunHeight                28.0f
#define kHappyPPPBtnHeight              32.f
#define kPPPBackBtnTag      384
#define kPPPPriceLabelTag   385

#define kPPPEnjoyBtn1Tag   386
#define kPPPEnjoyBtn2Tag   387
#define kPPPEnjoyBtn3Tag   388


@interface YCPPPView () <UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, retain) YCPPPModel *pModel;
@end

@implementation YCPPPView
{
    CGFloat rate ; // 校对比值
    CGFloat curWidth ;
    CGFloat curHeight ;
    CGFloat originBgWidthOfHeight;// 背景图片宽高比
    CGFloat loginBtnWidthOfBgWidth;
    CGFloat loginBtnHeightOfBgHeight;
    CGFloat findPwdBtnWidthOfBgWidth;
    CGFloat findPwdBtnHeightOfBgHeight;
    CGFloat textFieldHeightOfBgHeight;
    CGFloat topPadding;
    CGFloat leftPadding;
    CGFloat findBtnLeftPadding;
    CGFloat anotherLeftPadding;
    CGFloat gapPadding;
    CGFloat anotherGapPadding;
    CGFloat thirdGapPadding;
    CGFloat lineTopPadding;
    CGFloat backBtnWidthAndHeight;
    
    CGFloat keyboarHeight;
    CGFloat animatedDistance;
    
    UIImageView *mainBg;
    // for space
    UIView *ssView;
    
    UIButton *loginComfirmBtn;
    
    UITextField *nameTF;
    UITextField *pwdTF;
    UITextField *phoneInput;
    UITextField *codeInput;
    UITextField *realNameInput;
    UITextField *IDCardNumInput;
    
    BOOL pwdEntity;
    UIButton *eyesBtn;
    UIButton *forgetPwdBtn;
    
    YCBindMode m_mode;
    
    NSArray *mArr;
    NSDictionary *productInfo;
    UITableView *tPMethod;
    UITableView *tProduct;
    
//    YCPPPModel *pModel;
}

- (instancetype)initWithProvision:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        productInfo = dict.copy;
        [self _propertyInit];
//        [self _bgViewInit];
//        [self _ojbkInit];
        [self _xjbBgViewInit];
        [self _xjbInit];
    }
    return self;
}

- (instancetype)initWithProvision:(NSDictionary *)dict withModle:(YCPPPModel *)model
{
    self = [super init];
    if (self) {
        productInfo = dict.copy;
        self.pModel = model;
        [self _propertyInit];
        //        [self _bgViewInit];
        //        [self _ojbkInit];
        [self _xjbBgViewInit];
        [self _xjbInit];
    }
    return self;
}

- (void)_propertyInit
{
    rate = 0.8f; // 校对比值
    curWidth = winWidth;
    curHeight = winHeight;
    if (IS_IPAD) {
        curWidth = calculatedWidthAtIPad;
        curHeight = calculatedHeightAtIPad;
    }
    
    CGFloat realWidthHeightRate = curWidth/curHeight;
    
    originBgWidthOfHeight = 1070/1130.0f; // 原图宽高比
    //  157/228 =  0.68859
    //    CGFloat realWidthHeightRate = curHeight/curWidth;
    //    originBgWidthOfHeight = 228.0f/157; // 原图宽高比
    if (realWidthHeightRate >= originBgWidthOfHeight) {
        // 若设备的宽高比大于原图宽高比，则以设备的高度为基准，重新计算宽度
        curWidth = curHeight / originBgWidthOfHeight;
    } else {
        // 若设备的宽高比小于原图宽高比，则以设备的宽度为基准，重新计算高度
        curHeight = curWidth * originBgWidthOfHeight;
    }
    
    loginBtnWidthOfBgWidth = 914/1070.0f;
    loginBtnHeightOfBgHeight = 172/1130.0f;
    findPwdBtnWidthOfBgWidth = 300/1070.0f;
    findPwdBtnHeightOfBgHeight = 62/1130.0f;
    textFieldHeightOfBgHeight = 140/1130.0f;//150/1130.0f;//
    topPadding = 24/1130.0f;
    leftPadding = 24/1070.0f;
    anotherLeftPadding = 78/1130.0f;
    findBtnLeftPadding = (78+80)/1130.0f;
    gapPadding = 30/1130.0f;
    anotherGapPadding = 50/1130.0f;// origin 80
    thirdGapPadding = 64/1130.0f; // origin 34
    lineTopPadding = (156+172*4+50*3+70)/1130.0f;
    backBtnWidthAndHeight = 100.0f/1130.0f;
    
    pwdEntity = YES;
    
//    pModel = [YCDataUtils ycd_getPPP]; // 新方式下不需要从local获取，直接从外部获取
    
    NSMutableArray *pDetailList = [[NSMutableArray alloc] initWithCapacity:_pModel.detailList.count];
    for (PPPDetailModel *detail in _pModel.detailList) {
        [pDetailList addObject:detail];
    }
    mArr = pDetailList.copy;
    
}

- (void)_bgViewInit
{
    [self setFrame:CGRectMake(0, 0, winWidth, winHeight)];
    [self setBackgroundColor:[UIColor clearColor]];
    
    // bg
    CGFloat realWidth = rate*curWidth;
    CGFloat realHeight = rate*curHeight*0.8;

    mainBg = [[UIImageView alloc] init];
    mainBg.userInteractionEnabled = YES;
    [self addSubview:mainBg];
    [mainBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@(0));
        make.centerY.equalTo(@(0));
        make.width.equalTo(@(realWidth));
        make.height.equalTo(@(realHeight));
    }];

    mainBg.backgroundColor = [UIColor colorWithHexString:kBgGrayHex];
    mainBg.layer.borderWidth = 1;
    mainBg.layer.borderColor = [UIColor colorWithHexString:kGrayHex].CGColor;
    mainBg.layer.cornerRadius = 5.0f;
}

- (void)_ojbkInit
{
    CGFloat txtFieldWidth = loginBtnWidthOfBgWidth*rate*curWidth;
//    CGFloat txtFieldHeight = textFieldHeightOfBgHeight*rate*curWidth;
    
    CGFloat onCalHeight = rate*curHeight*0.8;
    CGFloat mTopPadding = 0;
    CGFloat firstGap = 26.0f/curWidth * onCalHeight;
    CGFloat secondGap = 8.0f/curWidth * onCalHeight;
    mTopPadding += firstGap/2;
    
    // back btn
    UIButton *backBtn = [HelloUtils ycu_initBtnWithNormalImage:backBtn_normal highlightedImage:backBtn_highlighted tag:kPPPBackBtnTag selector:@selector(pppViewBtnAction:) target:self];
    [mainBg addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(mTopPadding/2));
        make.left.equalTo(@(leftPadding*rate*curWidth));
        make.width.equalTo(@(backBtnWidthAndHeight*rate*curWidth));
        make.height.equalTo(@(backBtnWidthAndHeight*rate*curWidth));
    }];
    
    mTopPadding += backBtnWidthAndHeight*rate*curWidth;
    
    // 商品名称及价格
    UIView *productView = [[UIView alloc] initWithFrame:CGRectZero];
    productView.layer.borderWidth = 1.0f;
    productView.layer.borderColor = [UIColor colorWithHexString:kGrayHex].CGColor;
    [mainBg addSubview:productView];
    [productView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(mTopPadding));
        make.left.equalTo(@(anotherLeftPadding*rate*curWidth));
        make.width.equalTo(@(txtFieldWidth));
        make.height.equalTo(@(kGoodsNameAndPriceViewHeight));
    }];
    tProduct = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, txtFieldWidth, kGoodsNameAndPriceViewHeight)];
    tProduct.delegate = self;
    tProduct.dataSource = self;
    tProduct.scrollEnabled = NO;
    tProduct.allowsSelection = NO;
    [productView addSubview:tProduct];
    
    mTopPadding += secondGap*1.5f + kGoodsNameAndPriceViewHeight;
    
    // 选择支付方式
    UILabel *saySome = [[UILabel alloc] initWithFrame:CGRectZero];
    saySome.text = @"选择支付方式";
    saySome.backgroundColor = [UIColor clearColor];
    saySome.textColor = [UIColor colorWithHexString:kBlackHex];
    saySome.layer.borderWidth = 0.0f;
    [saySome setFont:[UIFont fontWithName:kTxtFontName size:kTxtFontSize]];
    [mainBg addSubview:saySome];
    CGSize saySize = [HelloUtils ycu_calculateSizeOfLabel:saySome];
    [saySome mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(mTopPadding));
        make.left.equalTo(@(anotherLeftPadding*rate*curWidth));
        make.width.equalTo(@(saySize.width));
        make.height.equalTo(@(saySize.height));
    }];
    
    // 支付方式框
    mTopPadding += secondGap*1.5f + saySize.height;
    
    UIView *methodView = [[UIView alloc] initWithFrame:CGRectZero];
    methodView.layer.borderWidth = 1.0f;
    methodView.layer.borderColor = [UIColor colorWithHexString:kGrayHex].CGColor;
    [mainBg addSubview:methodView];
    [methodView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(mTopPadding));
        make.left.equalTo(@(anotherLeftPadding*rate*curWidth));
        make.width.equalTo(@(txtFieldWidth));
        make.height.equalTo(@(kHulalaFunHeight*mArr.count));
    }];
    tPMethod = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, txtFieldWidth, kHulalaFunHeight*mArr.count)];
    tPMethod.delegate = self;
    tPMethod.dataSource = self;
    tPMethod.scrollEnabled = NO;
//    tPMethod.bounces = NO;
    tPMethod.rowHeight = kHulalaFunHeight;
    [methodView addSubview:tPMethod];
}

#pragma mark - xjb view

- (void)_xjbBgViewInit {
    [self setFrame:CGRectMake(0, 0, winWidth, winHeight)];
    [self setBackgroundColor:[UIColor clearColor]];
    
    mainBg = [[UIImageView alloc] init];
    mainBg.userInteractionEnabled = YES;
    mainBg.frame = CGRectZero;
    [self addSubview:mainBg];
//    mainBg.backgroundColor = [UIColor colorWithHexString:kBgGrayHex];
    mainBg.backgroundColor = [UIColor whiteColor];
    mainBg.layer.borderWidth = 1;
    mainBg.layer.borderColor = [UIColor colorWithHexString:kGrayHex].CGColor;
    mainBg.layer.cornerRadius = 5.0f;
}

- (void)_xjbInit {
    
    CGFloat xjbTopPadding = 5;
    // bg
    CGFloat realWidth = rate*curWidth;
//    CGFloat realHeight = rate*curHeight*0.8;
    
    // title lable
    // 选择支付方式
    UILabel *saySome = [[UILabel alloc] initWithFrame:CGRectZero];
//    saySome.text = @"选择支付方式";
    saySome.backgroundColor = [UIColor clearColor];
    NSDictionary *attDic = @{NSKernAttributeName:@(5.f),
                             NSForegroundColorAttributeName:[UIColor colorWithHexString:kBlackHex andAlpha:.7f],
                             NSFontAttributeName:[UIFont systemFontOfSize:16.f]
                             };
    NSMutableAttributedString *aTitle = [[NSMutableAttributedString alloc] initWithString:@"选择支付方式" attributes:attDic];
    saySome.attributedText = aTitle;
//    saySome.textColor = [UIColor colorWithHexString:kGreenHex];
//    saySome.textColor = [UIColor colorWithHexString:kGrayHex];
    saySome.layer.borderWidth = 0.0f;
//    [saySome setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20.f]];
//    [saySome setFont:[UIFont fontWithName:@"Helvetica" size:18.f]];
//    [saySome setFont:[UIFont systemFontOfSize:16.f]];
    [mainBg addSubview:saySome];
//    CGSize saySize = [HelloUtils ycu_calculateSizeOfLabel:saySome];
    CGSize saySize = [HelloUtils ycu_calculateSizeOfString:aTitle];
    [saySome mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(xjbTopPadding));
        make.centerX.equalTo(@(0));
        make.width.equalTo(@(saySize.width));
        make.height.equalTo(@(saySize.height));
    }];
    // close btn
    UIButton *backBtn = [HelloUtils ycu_initBtnWithNormalImage:@"btn_list_close.png" highlightedImage:nil tag:kPPPBackBtnTag selector:@selector(pppViewBtnAction:) target:self];
    [mainBg addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(5));
        make.right.equalTo(@(-10));
        make.width.equalTo(@(backBtnWidthAndHeight*rate*curWidth));
        make.height.equalTo(@(backBtnWidthAndHeight*rate*curWidth));
    }];
    // line
    xjbTopPadding += saySize.height + 5;
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectZero];
//    line.backgroundColor = [UIColor lightGrayColor];
    line.backgroundColor = [UIColor colorWithHexString:kGrayHex];
    [mainBg addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(xjbTopPadding));
        make.left.equalTo(@10);
        make.width.equalTo(@(realWidth-20));
        make.height.equalTo(@(0.5f));
    }];
    // ppp type below
    xjbTopPadding += 16;
    CGFloat btnw = realWidth-20.f;
    
    // 调整顺序，mababa tx job
    NSMutableArray *tmpArr = [[NSMutableArray alloc] initWithCapacity:mArr.count];
    for (PPPDetailModel *model in mArr) {
        if ([model.pType integerValue] != 1) {
            if ([model.pType integerValue]%2 == 0) {
                [tmpArr addObject:model];
            }
        }
    }
    for (PPPDetailModel *model in mArr) {
        if ([model.pType integerValue] != 1) {
            if ([model.pType integerValue]%2 == 1) {
                [tmpArr addObject:model];
            }
        }
    }
    for (PPPDetailModel *model in mArr) {
        if ([model.pType integerValue] == 1) {
            [tmpArr addObject:model];
        }
    }
    
    for (int i = 0; i < tmpArr.count; i++) {
        PPPDetailModel *model = tmpArr[i];
        UIButton * btn = [HelloUtils ycu_initBtnWithType:UIButtonTypeCustom
                                                   title:model.name
                                                     tag:[[HelloUtils ycu_paraseObjToStr:model.pType] integerValue]
                                                selector:@selector(happyAction:)
                                                  target:self];
        // mababa 1CACEC
        // tx   33A241
        // jobs 白色
        // %2==0 mababa %2==1 tx
        if ([model.pType integerValue] == 1) {
            // job
            btn.backgroundColor = [UIColor colorWithHexString:kBlackHex];
            [btn setTitleColor:[UIColor whiteColor] forState:0];
        } else {
            if ([model.pType integerValue]%2 == 1) {
                // tx
                btn.backgroundColor = [UIColor colorWithHexString:@"33A241"];
                [btn setTitleColor:[UIColor whiteColor] forState:0];
            } else {
                // mababa
                btn.backgroundColor = [UIColor colorWithHexString:@"1CACEC"];
                [btn setTitleColor:[UIColor whiteColor] forState:0];
            }
            [btn.layer setBorderWidth:0.f];
        }
        NSDictionary *attDic = @{NSKernAttributeName:@(10.f)};
        NSAttributedString *aTitle = [[NSAttributedString alloc] initWithString:model.name attributes:attDic];
        [btn.titleLabel setText:@""];
        [btn.titleLabel setAttributedText:aTitle];
        [btn.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:16]];
        [mainBg addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(@(0));
            make.top.equalTo(@(xjbTopPadding));
            make.width.equalTo(@(btnw));
            make.height.equalTo(@(kHappyPPPBtnHeight));
        }];
        
        xjbTopPadding += kHappyPPPBtnHeight + 8;
    }
    
    xjbTopPadding += 5;
    
    // 联系客服 --- 如充值有问题请联系客服，客服QQ：
    UILabel *csLb = [[UILabel alloc] initWithFrame:CGRectZero];
    NSString *csText = [NSString stringWithFormat:@"如充值有问题请联系客服,客服 QQ: %@",[YCDataUtils ycd_getCsQq]];
    csLb.text = csText;
    csLb.backgroundColor = [UIColor clearColor];
    csLb.textColor = [UIColor colorWithHexString:kBlackHex andAlpha:.6f];
    csLb.layer.borderWidth = 0.0f;
//    [csLb setFont:[UIFont fontWithName:kTxtFontName size:10.f]];
    [csLb setFont:[UIFont systemFontOfSize:10.f]];
    [mainBg addSubview:csLb];
    CGSize csSize = [HelloUtils ycu_calculateSizeOfLabel:csLb];
    [csLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(xjbTopPadding));
        make.left.equalTo(@(10));
        make.width.equalTo(@(csSize.width));
        make.height.equalTo(@(csSize.height));
    }];
    
    xjbTopPadding += csSize.height + 10;
//    NSLog(@"mTopPadding = %f, realHeight = %f, mainbgheight = %f",xjbTopPadding,realHeight,mainBg.frame.size.height);
    
    // 通过显示的 item 自动计算 mainbg 的高度
    [mainBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@(0));
        make.centerY.equalTo(@(0));
        make.width.equalTo(@(realWidth));
        make.height.equalTo(@(xjbTopPadding));
    }];
}

#pragma mark - Button Action

- (void)pppViewBtnAction:(UIButton *)sender
{
    [self removeFromSuperview];
}

- (void)happyAction:(UIButton *)sender {
    
    [self removeFromSuperview];
    
    if (sender.tag == 1) {
        [NetEngine yce_gotoHell:productInfo];
        return;
    }
    
    NSDictionary * dict = @{
                            kParmOrderId         : [HelloUtils ycu_paraseObjToStr:productInfo[kParmYcProductId]],
                            kParmPayType         : [HelloUtils ycu_paraseObjToStr:[NSString stringWithFormat:@"%ld", (long)sender.tag]],
                            };
    [HelloUtils ycu_sStarLoadingAtView:nil];
    [NetEngine yce_getPPPLinkWithParams:dict
                             completion:^(id result){
                                 [HelloUtils ycu_sStopLoadingAtView:nil];
                                 if ([result isKindOfClass:[NSDictionary class]]) {
                                     NSString *url = result[kParmData][kParmPayUrl];
                                     YCProtocol *web = [[YCProtocol alloc] initWithProtocolMode:YCProtocol_YCWebMode optionUrl:url close:^{
                                         // 查询是否 ppp 成功
                                         [NetEngine yce_pppIsFeelBetterWithOrderId:dict[kParmOrderId]
                                                                        completion:^(id result) {
                                                                            // 回调给CP，告知充值结果
                                                                            //  0\2 是失败，其他成功
                                                                            if ([result isKindOfClass:[NSDictionary class]]) {
                                                                                NSInteger statusCode = [result[kParmData][kParmPayStatus] integerValue];
                                                                                if (statusCode == 0 || statusCode == 2) {
                                                                                    POST_NOTE(NOTE_YC_PAY_FAIL)
                                                                                } else {
                                                                                    POST_NOTE(NOTE_YC_PAY_SUCCESS)
                                                                                }
                                                                            }
                                                                            
                                                                        }];
                                     }];
                                     [MainWindow addSubview:web.view];
                                 }
                             }];
}

#pragma mark - Table View Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:tProduct]) {
        return 1;
    }
    return mArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:tProduct]) {
        static NSString *indetity = @"product_cell";
        
        UITableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:indetity];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:indetity] ;
            
            UILabel *priceLB = [[UILabel alloc] initWithFrame:CGRectZero];
            priceLB.tag = kPPPPriceLabelTag;
            [cell.contentView addSubview:priceLB];
        }
        
        cell.textLabel.text = productInfo[YC_PRM_PAY_PRODUCT_NAME];
        UILabel *pLB = [cell viewWithTag:kPPPPriceLabelTag];
        pLB.text = [NSString stringWithFormat:@"￥%@",productInfo[YC_PRM_PAY_PRODUCT_PRICE]];

        CGSize pSize = [HelloUtils ycu_calculateSizeOfLabel:pLB];
        [cell.contentView addSubview:pLB];
        [pLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(@(0));
            make.right.equalTo(@(-10));
            make.width.equalTo(@(pSize.width));
            make.height.equalTo(@(pSize.height));
        }];
        
        return cell ;
    } else {
        static NSString *indetity = @"ppp_cell";
        
        UITableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:indetity];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:indetity] ;
        }
        
        PPPDetailModel *model = mArr[indexPath.row];
        cell.textLabel.text = model.name;
        
        return cell ;
    }
}

//点击选中表格行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:tProduct]) {
        return;
    }
    
    PPPDetailModel *model = mArr[indexPath.row];
    
    [self removeFromSuperview];
    
    if ([[HelloUtils ycu_paraseObjToStr:model.pType] isEqualToString:@"1"]) {
        
        [NetEngine yce_gotoHell:productInfo];
        
        return;
    }
    
    NSDictionary * dict = @{
                            kParmOrderId         : [HelloUtils ycu_paraseObjToStr:productInfo[kParmYcProductId]],
                            kParmPayType         : [HelloUtils ycu_paraseObjToStr:model.pType],
                            };
    [HelloUtils ycu_sStarLoadingAtView:nil];
    [NetEngine yce_getPPPLinkWithParams:dict
                            completion:^(id result){
                                [HelloUtils ycu_sStopLoadingAtView:nil];
                                if ([result isKindOfClass:[NSDictionary class]]) {
                                    NSString *url = result[kParmData][kParmPayUrl];
                                    YCProtocol *web = [[YCProtocol alloc] initWithProtocolMode:YCProtocol_YCWebMode optionUrl:url close:^{
                                        // 查询是否 ppp 成功
                                        [NetEngine yce_pppIsFeelBetterWithOrderId:dict[kParmOrderId]
                                                                      completion:^(id result) {
                                                                          // 回调给CP，告知充值结果
                                                                          //  0\2 是失败，其他成功
                                                                          if ([result isKindOfClass:[NSDictionary class]]) {
                                                                              NSInteger statusCode = [result[kParmData][kParmPayStatus] integerValue];
                                                                              if (statusCode == 0 || statusCode == 2) {
                                                                                  POST_NOTE(NOTE_YC_PAY_FAIL)
                                                                              } else {
                                                                                  POST_NOTE(NOTE_YC_PAY_SUCCESS)
                                                                              }
                                                                          }
                                                                          
                                                                      }];
                                    }];
                                    [MainWindow addSubview:web.view];
                                }
                            }];
    
}

@end
