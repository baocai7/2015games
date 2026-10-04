.class public Lcn/uc/gamesdk/GameUserLoginResult;
.super Ljava/lang/Object;


# instance fields
.field private _loginResult:I

.field private _sid:Ljava/lang/String;


# direct methods
.method public constructor <init>()V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public getLoginResult()I
    .locals 1

    iget v0, p0, Lcn/uc/gamesdk/GameUserLoginResult;->_loginResult:I

    return v0
.end method

.method public getSid()Ljava/lang/String;
    .locals 1

    iget-object v0, p0, Lcn/uc/gamesdk/GameUserLoginResult;->_sid:Ljava/lang/String;

    return-object v0
.end method

.method public setLoginResult(I)V
    .locals 0

    iput p1, p0, Lcn/uc/gamesdk/GameUserLoginResult;->_loginResult:I

    return-void
.end method

.method public setSid(Ljava/lang/String;)V
    .locals 0

    iput-object p1, p0, Lcn/uc/gamesdk/GameUserLoginResult;->_sid:Ljava/lang/String;

    return-void
.end method
