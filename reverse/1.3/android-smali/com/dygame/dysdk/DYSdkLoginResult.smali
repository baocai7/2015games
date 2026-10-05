.class public Lcom/dygame/dysdk/DYSdkLoginResult;
.super Ljava/lang/Object;
.source "DYSdkLoginResult.java"


# instance fields
.field private mOpenId:Ljava/lang/String;

.field private mParam:Ljava/lang/String;

.field private mToken:Ljava/lang/String;


# direct methods
.method public constructor <init>(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    .locals 1
    .param p1, "id"    # Ljava/lang/String;
    .param p2, "token"    # Ljava/lang/String;
    .param p3, "param"    # Ljava/lang/String;

    .prologue
    .line 8
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 4
    const-string v0, ""

    iput-object v0, p0, Lcom/dygame/dysdk/DYSdkLoginResult;->mOpenId:Ljava/lang/String;

    .line 5
    const-string v0, ""

    iput-object v0, p0, Lcom/dygame/dysdk/DYSdkLoginResult;->mToken:Ljava/lang/String;

    .line 6
    const-string v0, ""

    iput-object v0, p0, Lcom/dygame/dysdk/DYSdkLoginResult;->mParam:Ljava/lang/String;

    .line 9
    iput-object p1, p0, Lcom/dygame/dysdk/DYSdkLoginResult;->mOpenId:Ljava/lang/String;

    .line 10
    iput-object p2, p0, Lcom/dygame/dysdk/DYSdkLoginResult;->mToken:Ljava/lang/String;

    .line 11
    iput-object p3, p0, Lcom/dygame/dysdk/DYSdkLoginResult;->mParam:Ljava/lang/String;

    .line 12
    return-void
.end method


# virtual methods
.method public getOpenId()Ljava/lang/String;
    .locals 1

    .prologue
    .line 14
    iget-object v0, p0, Lcom/dygame/dysdk/DYSdkLoginResult;->mOpenId:Ljava/lang/String;

    return-object v0
.end method

.method public getParam()Ljava/lang/String;
    .locals 1

    .prologue
    .line 16
    iget-object v0, p0, Lcom/dygame/dysdk/DYSdkLoginResult;->mParam:Ljava/lang/String;

    return-object v0
.end method

.method public getToken()Ljava/lang/String;
    .locals 1

    .prologue
    .line 15
    iget-object v0, p0, Lcom/dygame/dysdk/DYSdkLoginResult;->mToken:Ljava/lang/String;

    return-object v0
.end method
