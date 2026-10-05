.class Lcom/dygame/common/DYCommon$DYCommonHandlerDemo;
.super Ljava/lang/Object;
.source "DYCommon.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/dygame/common/DYCommon;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0xa
    name = "DYCommonHandlerDemo"
.end annotation


# static fields
.field private static mInstance:Lcom/dygame/common/DYCommon$DYCommonHandlerDemo;


# instance fields
.field private mListener:I


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .prologue
    .line 118
    const/4 v0, 0x0

    sput-object v0, Lcom/dygame/common/DYCommon$DYCommonHandlerDemo;->mInstance:Lcom/dygame/common/DYCommon$DYCommonHandlerDemo;

    return-void
.end method

.method private constructor <init>()V
    .locals 1

    .prologue
    .line 117
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 127
    const/4 v0, -0x1

    iput v0, p0, Lcom/dygame/common/DYCommon$DYCommonHandlerDemo;->mListener:I

    return-void
.end method

.method public static getInstance()Lcom/dygame/common/DYCommon$DYCommonHandlerDemo;
    .locals 1

    .prologue
    .line 121
    sget-object v0, Lcom/dygame/common/DYCommon$DYCommonHandlerDemo;->mInstance:Lcom/dygame/common/DYCommon$DYCommonHandlerDemo;

    if-nez v0, :cond_0

    .line 122
    new-instance v0, Lcom/dygame/common/DYCommon$DYCommonHandlerDemo;

    invoke-direct {v0}, Lcom/dygame/common/DYCommon$DYCommonHandlerDemo;-><init>()V

    sput-object v0, Lcom/dygame/common/DYCommon$DYCommonHandlerDemo;->mInstance:Lcom/dygame/common/DYCommon$DYCommonHandlerDemo;

    .line 124
    :cond_0
    sget-object v0, Lcom/dygame/common/DYCommon$DYCommonHandlerDemo;->mInstance:Lcom/dygame/common/DYCommon$DYCommonHandlerDemo;

    return-object v0
.end method


# virtual methods
.method public doGotoLink(Ljava/lang/String;)V
    .locals 3
    .param p1, "param"    # Ljava/lang/String;

    .prologue
    .line 155
    :try_start_0
    invoke-static {p1}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v1

    .line 156
    .local v1, "uri":Landroid/net/Uri;
    new-instance v0, Landroid/content/Intent;

    const-string v2, "android.intent.action.VIEW"

    invoke-direct {v0, v2, v1}, Landroid/content/Intent;-><init>(Ljava/lang/String;Landroid/net/Uri;)V

    .line 157
    .local v0, "it":Landroid/content/Intent;
    sget-object v2, Lcom/dygame/common/DYGame;->theActivity:Lcom/dygame/common/DYGame;

    invoke-virtual {v2, v0}, Lcom/dygame/common/DYGame;->startActivity(Landroid/content/Intent;)V
    :try_end_0
    .catch Ljava/lang/Error; {:try_start_0 .. :try_end_0} :catch_1
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 161
    .end local v0    # "it":Landroid/content/Intent;
    .end local v1    # "uri":Landroid/net/Uri;
    :goto_0
    return-void

    .line 159
    :catch_0
    move-exception v2

    goto :goto_0

    .line 158
    :catch_1
    move-exception v2

    goto :goto_0
.end method

.method public doTryQuit(Ljava/lang/String;)V
    .locals 3
    .param p1, "param"    # Ljava/lang/String;

    .prologue
    .line 137
    const-string v0, "DYCommon"

    invoke-static {v0, p1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 139
    const-string v0, "1"

    invoke-virtual {p1, v0}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_0

    const-string v0, "true"

    invoke-virtual {p1, v0}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_1

    .line 140
    :cond_0
    sget-object v0, Lcom/dygame/common/DYGame;->theActivity:Lcom/dygame/common/DYGame;

    invoke-virtual {v0}, Lcom/dygame/common/DYGame;->finish()V

    .line 145
    :goto_0
    return-void

    .line 142
    :cond_1
    const-string v0, "EVENT_IGNORE"

    const-string v1, ""

    iget v2, p0, Lcom/dygame/common/DYCommon$DYCommonHandlerDemo;->mListener:I

    invoke-static {v0, v1, v2}, Lcom/dygame/common/DYCommon;->notifyScriptListener(Ljava/lang/String;Ljava/lang/String;I)V

    .line 143
    const/4 v0, -0x1

    iput v0, p0, Lcom/dygame/common/DYCommon$DYCommonHandlerDemo;->mListener:I

    goto :goto_0
.end method

.method public tryGotoLink(Ljava/lang/String;)V
    .locals 2
    .param p1, "param"    # Ljava/lang/String;

    .prologue
    .line 149
    sget-object v0, Lcom/dygame/common/DYCommon$DYCommonHandlerDemo;->mInstance:Lcom/dygame/common/DYCommon$DYCommonHandlerDemo;

    const-string v1, "doGotoLink"

    invoke-static {v0, v1, p1}, Lcom/dygame/common/DYThreadHelper;->runOnUIThread(Ljava/lang/Object;Ljava/lang/String;Ljava/lang/String;)V

    .line 150
    return-void
.end method

.method public tryQuit(Ljava/lang/String;I)V
    .locals 2
    .param p1, "param"    # Ljava/lang/String;
    .param p2, "listener"    # I

    .prologue
    .line 131
    iput p2, p0, Lcom/dygame/common/DYCommon$DYCommonHandlerDemo;->mListener:I

    .line 132
    sget-object v0, Lcom/dygame/common/DYCommon$DYCommonHandlerDemo;->mInstance:Lcom/dygame/common/DYCommon$DYCommonHandlerDemo;

    const-string v1, "doTryQuit"

    invoke-static {v0, v1, p1}, Lcom/dygame/common/DYThreadHelper;->runOnUIThread(Ljava/lang/Object;Ljava/lang/String;Ljava/lang/String;)V

    .line 133
    return-void
.end method
