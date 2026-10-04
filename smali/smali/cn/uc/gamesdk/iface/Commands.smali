.class public final enum Lcn/uc/gamesdk/iface/Commands;
.super Ljava/lang/Enum;


# annotations
.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Enum",
        "<",
        "Lcn/uc/gamesdk/iface/Commands;",
        ">;"
    }
.end annotation


# static fields
.field private static final synthetic $VALUES:[Lcn/uc/gamesdk/iface/Commands;

.field public static final enum ActivityCallback:Lcn/uc/gamesdk/iface/Commands;

.field public static final enum BindGuest:Lcn/uc/gamesdk/iface/Commands;

.field public static final enum CheckAndDownload:Lcn/uc/gamesdk/iface/Commands;

.field public static final enum CreateFloatButton:Lcn/uc/gamesdk/iface/Commands;

.field public static final enum DestroyFloatButton:Lcn/uc/gamesdk/iface/Commands;

.field public static final enum EnterUI:Lcn/uc/gamesdk/iface/Commands;

.field public static final enum EnterUserCenter:Lcn/uc/gamesdk/iface/Commands;

.field public static final enum ExitSdk:Lcn/uc/gamesdk/iface/Commands;

.field public static final enum GetSid:Lcn/uc/gamesdk/iface/Commands;

.field public static final enum GetUCVipInfo:Lcn/uc/gamesdk/iface/Commands;

.field public static final enum GetUCZoneFriendList:Lcn/uc/gamesdk/iface/Commands;

.field public static final enum InitSdk:Lcn/uc/gamesdk/iface/Commands;

.field public static final enum IsUCVip:Lcn/uc/gamesdk/iface/Commands;

.field public static final enum Login:Lcn/uc/gamesdk/iface/Commands;

.field public static final enum LoginGuest:Lcn/uc/gamesdk/iface/Commands;

.field public static final enum Logout:Lcn/uc/gamesdk/iface/Commands;

.field public static final enum NotifyZone:Lcn/uc/gamesdk/iface/Commands;

.field public static final enum Pay:Lcn/uc/gamesdk/iface/Commands;

.field public static final enum SetLogoutNotifyListener:Lcn/uc/gamesdk/iface/Commands;

.field public static final enum ShowFloatButton:Lcn/uc/gamesdk/iface/Commands;

.field public static final enum SubmitExtendData:Lcn/uc/gamesdk/iface/Commands;

.field public static final enum UPointCharge:Lcn/uc/gamesdk/iface/Commands;

.field public static final enum Unzip:Lcn/uc/gamesdk/iface/Commands;


# direct methods
.method static constructor <clinit>()V
    .locals 8

    const/4 v7, 0x4

    const/4 v6, 0x3

    const/4 v5, 0x2

    const/4 v4, 0x1

    const/4 v3, 0x0

    new-instance v0, Lcn/uc/gamesdk/iface/Commands;

    const-string v1, "InitSdk"

    invoke-direct {v0, v1, v3}, Lcn/uc/gamesdk/iface/Commands;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lcn/uc/gamesdk/iface/Commands;->InitSdk:Lcn/uc/gamesdk/iface/Commands;

    new-instance v0, Lcn/uc/gamesdk/iface/Commands;

    const-string v1, "GetSid"

    invoke-direct {v0, v1, v4}, Lcn/uc/gamesdk/iface/Commands;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lcn/uc/gamesdk/iface/Commands;->GetSid:Lcn/uc/gamesdk/iface/Commands;

    new-instance v0, Lcn/uc/gamesdk/iface/Commands;

    const-string v1, "IsUCVip"

    invoke-direct {v0, v1, v5}, Lcn/uc/gamesdk/iface/Commands;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lcn/uc/gamesdk/iface/Commands;->IsUCVip:Lcn/uc/gamesdk/iface/Commands;

    new-instance v0, Lcn/uc/gamesdk/iface/Commands;

    const-string v1, "Login"

    invoke-direct {v0, v1, v6}, Lcn/uc/gamesdk/iface/Commands;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lcn/uc/gamesdk/iface/Commands;->Login:Lcn/uc/gamesdk/iface/Commands;

    new-instance v0, Lcn/uc/gamesdk/iface/Commands;

    const-string v1, "Pay"

    invoke-direct {v0, v1, v7}, Lcn/uc/gamesdk/iface/Commands;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lcn/uc/gamesdk/iface/Commands;->Pay:Lcn/uc/gamesdk/iface/Commands;

    new-instance v0, Lcn/uc/gamesdk/iface/Commands;

    const-string v1, "EnterUI"

    const/4 v2, 0x5

    invoke-direct {v0, v1, v2}, Lcn/uc/gamesdk/iface/Commands;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lcn/uc/gamesdk/iface/Commands;->EnterUI:Lcn/uc/gamesdk/iface/Commands;

    new-instance v0, Lcn/uc/gamesdk/iface/Commands;

    const-string v1, "GetUCVipInfo"

    const/4 v2, 0x6

    invoke-direct {v0, v1, v2}, Lcn/uc/gamesdk/iface/Commands;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lcn/uc/gamesdk/iface/Commands;->GetUCVipInfo:Lcn/uc/gamesdk/iface/Commands;

    new-instance v0, Lcn/uc/gamesdk/iface/Commands;

    const-string v1, "GetUCZoneFriendList"

    const/4 v2, 0x7

    invoke-direct {v0, v1, v2}, Lcn/uc/gamesdk/iface/Commands;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lcn/uc/gamesdk/iface/Commands;->GetUCZoneFriendList:Lcn/uc/gamesdk/iface/Commands;

    new-instance v0, Lcn/uc/gamesdk/iface/Commands;

    const-string v1, "EnterUserCenter"

    const/16 v2, 0x8

    invoke-direct {v0, v1, v2}, Lcn/uc/gamesdk/iface/Commands;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lcn/uc/gamesdk/iface/Commands;->EnterUserCenter:Lcn/uc/gamesdk/iface/Commands;

    new-instance v0, Lcn/uc/gamesdk/iface/Commands;

    const-string v1, "SubmitExtendData"

    const/16 v2, 0x9

    invoke-direct {v0, v1, v2}, Lcn/uc/gamesdk/iface/Commands;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lcn/uc/gamesdk/iface/Commands;->SubmitExtendData:Lcn/uc/gamesdk/iface/Commands;

    new-instance v0, Lcn/uc/gamesdk/iface/Commands;

    const-string v1, "NotifyZone"

    const/16 v2, 0xa

    invoke-direct {v0, v1, v2}, Lcn/uc/gamesdk/iface/Commands;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lcn/uc/gamesdk/iface/Commands;->NotifyZone:Lcn/uc/gamesdk/iface/Commands;

    new-instance v0, Lcn/uc/gamesdk/iface/Commands;

    const-string v1, "CreateFloatButton"

    const/16 v2, 0xb

    invoke-direct {v0, v1, v2}, Lcn/uc/gamesdk/iface/Commands;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lcn/uc/gamesdk/iface/Commands;->CreateFloatButton:Lcn/uc/gamesdk/iface/Commands;

    new-instance v0, Lcn/uc/gamesdk/iface/Commands;

    const-string v1, "ShowFloatButton"

    const/16 v2, 0xc

    invoke-direct {v0, v1, v2}, Lcn/uc/gamesdk/iface/Commands;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lcn/uc/gamesdk/iface/Commands;->ShowFloatButton:Lcn/uc/gamesdk/iface/Commands;

    new-instance v0, Lcn/uc/gamesdk/iface/Commands;

    const-string v1, "DestroyFloatButton"

    const/16 v2, 0xd

    invoke-direct {v0, v1, v2}, Lcn/uc/gamesdk/iface/Commands;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lcn/uc/gamesdk/iface/Commands;->DestroyFloatButton:Lcn/uc/gamesdk/iface/Commands;

    new-instance v0, Lcn/uc/gamesdk/iface/Commands;

    const-string v1, "LoginGuest"

    const/16 v2, 0xe

    invoke-direct {v0, v1, v2}, Lcn/uc/gamesdk/iface/Commands;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lcn/uc/gamesdk/iface/Commands;->LoginGuest:Lcn/uc/gamesdk/iface/Commands;

    new-instance v0, Lcn/uc/gamesdk/iface/Commands;

    const-string v1, "BindGuest"

    const/16 v2, 0xf

    invoke-direct {v0, v1, v2}, Lcn/uc/gamesdk/iface/Commands;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lcn/uc/gamesdk/iface/Commands;->BindGuest:Lcn/uc/gamesdk/iface/Commands;

    new-instance v0, Lcn/uc/gamesdk/iface/Commands;

    const-string v1, "UPointCharge"

    const/16 v2, 0x10

    invoke-direct {v0, v1, v2}, Lcn/uc/gamesdk/iface/Commands;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lcn/uc/gamesdk/iface/Commands;->UPointCharge:Lcn/uc/gamesdk/iface/Commands;

    new-instance v0, Lcn/uc/gamesdk/iface/Commands;

    const-string v1, "Logout"

    const/16 v2, 0x11

    invoke-direct {v0, v1, v2}, Lcn/uc/gamesdk/iface/Commands;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lcn/uc/gamesdk/iface/Commands;->Logout:Lcn/uc/gamesdk/iface/Commands;

    new-instance v0, Lcn/uc/gamesdk/iface/Commands;

    const-string v1, "ExitSdk"

    const/16 v2, 0x12

    invoke-direct {v0, v1, v2}, Lcn/uc/gamesdk/iface/Commands;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lcn/uc/gamesdk/iface/Commands;->ExitSdk:Lcn/uc/gamesdk/iface/Commands;

    new-instance v0, Lcn/uc/gamesdk/iface/Commands;

    const-string v1, "SetLogoutNotifyListener"

    const/16 v2, 0x13

    invoke-direct {v0, v1, v2}, Lcn/uc/gamesdk/iface/Commands;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lcn/uc/gamesdk/iface/Commands;->SetLogoutNotifyListener:Lcn/uc/gamesdk/iface/Commands;

    new-instance v0, Lcn/uc/gamesdk/iface/Commands;

    const-string v1, "CheckAndDownload"

    const/16 v2, 0x14

    invoke-direct {v0, v1, v2}, Lcn/uc/gamesdk/iface/Commands;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lcn/uc/gamesdk/iface/Commands;->CheckAndDownload:Lcn/uc/gamesdk/iface/Commands;

    new-instance v0, Lcn/uc/gamesdk/iface/Commands;

    const-string v1, "Unzip"

    const/16 v2, 0x15

    invoke-direct {v0, v1, v2}, Lcn/uc/gamesdk/iface/Commands;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lcn/uc/gamesdk/iface/Commands;->Unzip:Lcn/uc/gamesdk/iface/Commands;

    new-instance v0, Lcn/uc/gamesdk/iface/Commands;

    const-string v1, "ActivityCallback"

    const/16 v2, 0x16

    invoke-direct {v0, v1, v2}, Lcn/uc/gamesdk/iface/Commands;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lcn/uc/gamesdk/iface/Commands;->ActivityCallback:Lcn/uc/gamesdk/iface/Commands;

    const/16 v0, 0x17

    new-array v0, v0, [Lcn/uc/gamesdk/iface/Commands;

    sget-object v1, Lcn/uc/gamesdk/iface/Commands;->InitSdk:Lcn/uc/gamesdk/iface/Commands;

    aput-object v1, v0, v3

    sget-object v1, Lcn/uc/gamesdk/iface/Commands;->GetSid:Lcn/uc/gamesdk/iface/Commands;

    aput-object v1, v0, v4

    sget-object v1, Lcn/uc/gamesdk/iface/Commands;->IsUCVip:Lcn/uc/gamesdk/iface/Commands;

    aput-object v1, v0, v5

    sget-object v1, Lcn/uc/gamesdk/iface/Commands;->Login:Lcn/uc/gamesdk/iface/Commands;

    aput-object v1, v0, v6

    sget-object v1, Lcn/uc/gamesdk/iface/Commands;->Pay:Lcn/uc/gamesdk/iface/Commands;

    aput-object v1, v0, v7

    const/4 v1, 0x5

    sget-object v2, Lcn/uc/gamesdk/iface/Commands;->EnterUI:Lcn/uc/gamesdk/iface/Commands;

    aput-object v2, v0, v1

    const/4 v1, 0x6

    sget-object v2, Lcn/uc/gamesdk/iface/Commands;->GetUCVipInfo:Lcn/uc/gamesdk/iface/Commands;

    aput-object v2, v0, v1

    const/4 v1, 0x7

    sget-object v2, Lcn/uc/gamesdk/iface/Commands;->GetUCZoneFriendList:Lcn/uc/gamesdk/iface/Commands;

    aput-object v2, v0, v1

    const/16 v1, 0x8

    sget-object v2, Lcn/uc/gamesdk/iface/Commands;->EnterUserCenter:Lcn/uc/gamesdk/iface/Commands;

    aput-object v2, v0, v1

    const/16 v1, 0x9

    sget-object v2, Lcn/uc/gamesdk/iface/Commands;->SubmitExtendData:Lcn/uc/gamesdk/iface/Commands;

    aput-object v2, v0, v1

    const/16 v1, 0xa

    sget-object v2, Lcn/uc/gamesdk/iface/Commands;->NotifyZone:Lcn/uc/gamesdk/iface/Commands;

    aput-object v2, v0, v1

    const/16 v1, 0xb

    sget-object v2, Lcn/uc/gamesdk/iface/Commands;->CreateFloatButton:Lcn/uc/gamesdk/iface/Commands;

    aput-object v2, v0, v1

    const/16 v1, 0xc

    sget-object v2, Lcn/uc/gamesdk/iface/Commands;->ShowFloatButton:Lcn/uc/gamesdk/iface/Commands;

    aput-object v2, v0, v1

    const/16 v1, 0xd

    sget-object v2, Lcn/uc/gamesdk/iface/Commands;->DestroyFloatButton:Lcn/uc/gamesdk/iface/Commands;

    aput-object v2, v0, v1

    const/16 v1, 0xe

    sget-object v2, Lcn/uc/gamesdk/iface/Commands;->LoginGuest:Lcn/uc/gamesdk/iface/Commands;

    aput-object v2, v0, v1

    const/16 v1, 0xf

    sget-object v2, Lcn/uc/gamesdk/iface/Commands;->BindGuest:Lcn/uc/gamesdk/iface/Commands;

    aput-object v2, v0, v1

    const/16 v1, 0x10

    sget-object v2, Lcn/uc/gamesdk/iface/Commands;->UPointCharge:Lcn/uc/gamesdk/iface/Commands;

    aput-object v2, v0, v1

    const/16 v1, 0x11

    sget-object v2, Lcn/uc/gamesdk/iface/Commands;->Logout:Lcn/uc/gamesdk/iface/Commands;

    aput-object v2, v0, v1

    const/16 v1, 0x12

    sget-object v2, Lcn/uc/gamesdk/iface/Commands;->ExitSdk:Lcn/uc/gamesdk/iface/Commands;

    aput-object v2, v0, v1

    const/16 v1, 0x13

    sget-object v2, Lcn/uc/gamesdk/iface/Commands;->SetLogoutNotifyListener:Lcn/uc/gamesdk/iface/Commands;

    aput-object v2, v0, v1

    const/16 v1, 0x14

    sget-object v2, Lcn/uc/gamesdk/iface/Commands;->CheckAndDownload:Lcn/uc/gamesdk/iface/Commands;

    aput-object v2, v0, v1

    const/16 v1, 0x15

    sget-object v2, Lcn/uc/gamesdk/iface/Commands;->Unzip:Lcn/uc/gamesdk/iface/Commands;

    aput-object v2, v0, v1

    const/16 v1, 0x16

    sget-object v2, Lcn/uc/gamesdk/iface/Commands;->ActivityCallback:Lcn/uc/gamesdk/iface/Commands;

    aput-object v2, v0, v1

    sput-object v0, Lcn/uc/gamesdk/iface/Commands;->$VALUES:[Lcn/uc/gamesdk/iface/Commands;

    return-void
.end method

.method private constructor <init>(Ljava/lang/String;I)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    invoke-direct {p0, p1, p2}, Ljava/lang/Enum;-><init>(Ljava/lang/String;I)V

    return-void
.end method

.method public static getCommand(Ljava/lang/String;)Lcn/uc/gamesdk/iface/Commands;
    .locals 2

    const/4 v0, 0x0

    :try_start_0
    invoke-static {p0}, Lcn/uc/gamesdk/iface/Commands;->valueOf(Ljava/lang/String;)Lcn/uc/gamesdk/iface/Commands;
    :try_end_0
    .catch Ljava/lang/IllegalArgumentException; {:try_start_0 .. :try_end_0} :catch_0

    move-result-object v0

    :goto_0
    return-object v0

    :catch_0
    move-exception v1

    invoke-virtual {v1}, Ljava/lang/IllegalArgumentException;->printStackTrace()V

    goto :goto_0
.end method

.method public static valueOf(Ljava/lang/String;)Lcn/uc/gamesdk/iface/Commands;
    .locals 1

    const-class v0, Lcn/uc/gamesdk/iface/Commands;

    invoke-static {v0, p0}, Ljava/lang/Enum;->valueOf(Ljava/lang/Class;Ljava/lang/String;)Ljava/lang/Enum;

    move-result-object v0

    check-cast v0, Lcn/uc/gamesdk/iface/Commands;

    return-object v0
.end method

.method public static values()[Lcn/uc/gamesdk/iface/Commands;
    .locals 1

    sget-object v0, Lcn/uc/gamesdk/iface/Commands;->$VALUES:[Lcn/uc/gamesdk/iface/Commands;

    invoke-virtual {v0}, [Lcn/uc/gamesdk/iface/Commands;->clone()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, [Lcn/uc/gamesdk/iface/Commands;

    return-object v0
.end method
