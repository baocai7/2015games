.class Lcom/dygame/common/DYShareMgr$DYShareHandlerDemo;
.super Ljava/lang/Object;
.source "DYShareMgr.java"

# interfaces
.implements Lcom/dygame/common/DYShareMgr$DYShareHandler;
.implements Landroid/preference/PreferenceManager$OnActivityResultListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/dygame/common/DYShareMgr;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0xa
    name = "DYShareHandlerDemo"
.end annotation


# static fields
.field private static mInstance:Lcom/dygame/common/DYShareMgr$DYShareHandlerDemo;


# instance fields
.field private mListener:I


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .prologue
    .line 59
    const/4 v0, 0x0

    sput-object v0, Lcom/dygame/common/DYShareMgr$DYShareHandlerDemo;->mInstance:Lcom/dygame/common/DYShareMgr$DYShareHandlerDemo;

    return-void
.end method

.method private constructor <init>()V
    .locals 1

    .prologue
    .line 58
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 67
    const/4 v0, -0x1

    iput v0, p0, Lcom/dygame/common/DYShareMgr$DYShareHandlerDemo;->mListener:I

    return-void
.end method

.method private doShareDefault(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    .locals 5
    .param p1, "title"    # Ljava/lang/String;
    .param p2, "content"    # Ljava/lang/String;
    .param p3, "path"    # Ljava/lang/String;

    .prologue
    .line 135
    new-instance v1, Landroid/content/Intent;

    const-string v2, "android.intent.action.SEND"

    invoke-direct {v1, v2}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    .line 136
    .local v1, "share":Landroid/content/Intent;
    const-string v2, "image/*"

    invoke-virtual {v1, v2}, Landroid/content/Intent;->setType(Ljava/lang/String;)Landroid/content/Intent;

    .line 138
    const-string v2, "android.intent.extra.TITLE"

    invoke-virtual {v1, v2, p1}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;

    .line 139
    const-string v2, "android.intent.extra.SUBJECT"

    invoke-virtual {v1, v2, p1}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;

    .line 140
    const-string v2, "android.intent.extra.TEXT"

    invoke-virtual {v1, v2, p2}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;

    .line 141
    const-string v2, "sms_body"

    invoke-virtual {v1, v2, p2}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;

    .line 142
    const-string v2, "android.intent.extra.STREAM"

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "file://"

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v3}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v3

    invoke-virtual {v1, v2, v3}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Landroid/os/Parcelable;)Landroid/content/Intent;

    .line 143
    invoke-static {v1, p3}, Landroid/content/Intent;->createChooser(Landroid/content/Intent;Ljava/lang/CharSequence;)Landroid/content/Intent;

    move-result-object v0

    .line 145
    .local v0, "chooserIntent":Landroid/content/Intent;
    sget-object v2, Lcom/dygame/common/DYGame;->theActivity:Lcom/dygame/common/DYGame;

    sget v3, Lcom/dygame/common/DYConst;->REQ_CODE_DEFAULT:I

    invoke-virtual {v2, v0, v3}, Lcom/dygame/common/DYGame;->startActivityForResult(Landroid/content/Intent;I)V

    .line 146
    return-void
.end method

.method private doShareWeibo(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    .locals 5
    .param p1, "title"    # Ljava/lang/String;
    .param p2, "content"    # Ljava/lang/String;
    .param p3, "path"    # Ljava/lang/String;

    .prologue
    .line 148
    new-instance v1, Landroid/content/Intent;

    const-string v2, "android.intent.action.SEND"

    invoke-direct {v1, v2}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    .line 149
    .local v1, "share":Landroid/content/Intent;
    const-string v2, "image/*"

    invoke-virtual {v1, v2}, Landroid/content/Intent;->setType(Ljava/lang/String;)Landroid/content/Intent;

    .line 151
    const-string v2, "android.intent.extra.TITLE"

    invoke-virtual {v1, v2, p1}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;

    .line 152
    const-string v2, "android.intent.extra.SUBJECT"

    invoke-virtual {v1, v2, p1}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;

    .line 153
    const-string v2, "android.intent.extra.TEXT"

    invoke-virtual {v1, v2, p2}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;

    .line 154
    const-string v2, "sms_body"

    invoke-virtual {v1, v2, p2}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;

    .line 155
    const-string v2, "android.intent.extra.STREAM"

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "file://"

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v3}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v3

    invoke-virtual {v1, v2, v3}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Landroid/os/Parcelable;)Landroid/content/Intent;

    .line 157
    new-instance v0, Landroid/content/ComponentName;

    const-string v2, "com.sina.weibo"

    const-string v3, "com.sina.weibo.EditActivity"

    invoke-direct {v0, v2, v3}, Landroid/content/ComponentName;-><init>(Ljava/lang/String;Ljava/lang/String;)V

    .line 159
    .local v0, "cn":Landroid/content/ComponentName;
    invoke-virtual {v1, v0}, Landroid/content/Intent;->setComponent(Landroid/content/ComponentName;)Landroid/content/Intent;

    .line 161
    sget-object v2, Lcom/dygame/common/DYGame;->theActivity:Lcom/dygame/common/DYGame;

    sget v3, Lcom/dygame/common/DYConst;->REQ_CODE_WEIBO:I

    invoke-virtual {v2, v1, v3}, Lcom/dygame/common/DYGame;->startActivityForResult(Landroid/content/Intent;I)V

    .line 162
    return-void
.end method

.method private doShareWeixin(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    .locals 5
    .param p1, "title"    # Ljava/lang/String;
    .param p2, "content"    # Ljava/lang/String;
    .param p3, "path"    # Ljava/lang/String;

    .prologue
    .line 164
    new-instance v1, Landroid/content/Intent;

    const-string v2, "android.intent.action.SEND"

    invoke-direct {v1, v2}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    .line 165
    .local v1, "share":Landroid/content/Intent;
    const-string v2, "image/*"

    invoke-virtual {v1, v2}, Landroid/content/Intent;->setType(Ljava/lang/String;)Landroid/content/Intent;

    .line 167
    const-string v2, "android.intent.extra.TITLE"

    invoke-virtual {v1, v2, p1}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;

    .line 168
    const-string v2, "android.intent.extra.SUBJECT"

    invoke-virtual {v1, v2, p1}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;

    .line 169
    const-string v2, "android.intent.extra.TEXT"

    invoke-virtual {v1, v2, p2}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;

    .line 170
    const-string v2, "sms_body"

    invoke-virtual {v1, v2, p2}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;

    .line 171
    const-string v2, "android.intent.extra.STREAM"

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "file://"

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v3}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v3

    invoke-virtual {v1, v2, v3}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Landroid/os/Parcelable;)Landroid/content/Intent;

    .line 173
    new-instance v0, Landroid/content/ComponentName;

    const-string v2, "com.tencent.mm"

    const-string v3, "com.tencent.mm.ui.tools.ShareToTimeLineUI"

    invoke-direct {v0, v2, v3}, Landroid/content/ComponentName;-><init>(Ljava/lang/String;Ljava/lang/String;)V

    .line 175
    .local v0, "cn":Landroid/content/ComponentName;
    invoke-virtual {v1, v0}, Landroid/content/Intent;->setComponent(Landroid/content/ComponentName;)Landroid/content/Intent;

    .line 177
    sget-object v2, Lcom/dygame/common/DYGame;->theActivity:Lcom/dygame/common/DYGame;

    sget v3, Lcom/dygame/common/DYConst;->REQ_CODE_WEIXIN:I

    invoke-virtual {v2, v1, v3}, Lcom/dygame/common/DYGame;->startActivityForResult(Landroid/content/Intent;I)V

    .line 178
    return-void
.end method

.method private getExternalStoragePath()Ljava/lang/String;
    .locals 4

    .prologue
    .line 265
    invoke-static {}, Landroid/os/Environment;->getExternalStorageState()Ljava/lang/String;

    move-result-object v1

    .line 268
    .local v1, "state":Ljava/lang/String;
    const-string v2, "mounted"

    invoke-virtual {v2, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_1

    .line 269
    invoke-static {}, Landroid/os/Environment;->getExternalStorageDirectory()Ljava/io/File;

    move-result-object v2

    invoke-virtual {v2}, Ljava/io/File;->canWrite()Z

    move-result v2

    if-eqz v2, :cond_1

    .line 271
    invoke-static {}, Landroid/os/Environment;->getExternalStorageDirectory()Ljava/io/File;

    move-result-object v2

    invoke-virtual {v2}, Ljava/io/File;->getPath()Ljava/lang/String;

    move-result-object v0

    .line 272
    .local v0, "path":Ljava/lang/String;
    const-string v2, "/"

    invoke-virtual {v0, v2}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    move-result v2

    if-nez v2, :cond_0

    .line 273
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, "/"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 278
    .end local v0    # "path":Ljava/lang/String;
    :cond_0
    :goto_0
    return-object v0

    :cond_1
    const/4 v0, 0x0

    goto :goto_0
.end method

.method public static getInstance()Lcom/dygame/common/DYShareMgr$DYShareHandlerDemo;
    .locals 1

    .prologue
    .line 61
    sget-object v0, Lcom/dygame/common/DYShareMgr$DYShareHandlerDemo;->mInstance:Lcom/dygame/common/DYShareMgr$DYShareHandlerDemo;

    if-nez v0, :cond_0

    .line 62
    new-instance v0, Lcom/dygame/common/DYShareMgr$DYShareHandlerDemo;

    invoke-direct {v0}, Lcom/dygame/common/DYShareMgr$DYShareHandlerDemo;-><init>()V

    sput-object v0, Lcom/dygame/common/DYShareMgr$DYShareHandlerDemo;->mInstance:Lcom/dygame/common/DYShareMgr$DYShareHandlerDemo;

    .line 64
    :cond_0
    sget-object v0, Lcom/dygame/common/DYShareMgr$DYShareHandlerDemo;->mInstance:Lcom/dygame/common/DYShareMgr$DYShareHandlerDemo;

    return-object v0
.end method

.method private getShareFilePath(Ljava/lang/String;)Ljava/lang/String;
    .locals 7
    .param p1, "param"    # Ljava/lang/String;

    .prologue
    .line 283
    invoke-direct {p0}, Lcom/dygame/common/DYShareMgr$DYShareHandlerDemo;->getExternalStoragePath()Ljava/lang/String;

    move-result-object v2

    .line 284
    .local v2, "propPath":Ljava/lang/String;
    if-nez v2, :cond_0

    .line 285
    const-string v2, "/"

    .line 287
    :cond_0
    sget-object v5, Lcom/dygame/common/DYGame;->theActivity:Lcom/dygame/common/DYGame;

    invoke-virtual {v5}, Lcom/dygame/common/DYGame;->getPackageName()Ljava/lang/String;

    move-result-object v3

    .line 288
    .local v3, "strAppDir":Ljava/lang/String;
    sget-object v5, Lcom/dygame/common/DYGame;->theActivity:Lcom/dygame/common/DYGame;

    const v6, 0x7f060023

    invoke-virtual {v5, v6}, Lcom/dygame/common/DYGame;->getString(I)Ljava/lang/String;

    move-result-object v4

    .line 290
    .local v4, "strAppName":Ljava/lang/String;
    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v5, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    const-string v6, "dygame/"

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    const-string v6, "/"

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    const-string v6, ".jpg"

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 293
    .local v0, "filePath":Ljava/lang/String;
    const-string v1, "assets/"

    .line 294
    .local v1, "pathAssets":Ljava/lang/String;
    invoke-virtual {p1, v1}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v5

    if-eqz v5, :cond_1

    .line 295
    sget-object v5, Lcom/dygame/common/DYGame;->theActivity:Lcom/dygame/common/DYGame;

    invoke-virtual {v1}, Ljava/lang/String;->length()I

    move-result v6

    invoke-virtual {p1, v6}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object v6

    invoke-direct {p0, v5, v6, v0}, Lcom/dygame/common/DYShareMgr$DYShareHandlerDemo;->retrieveFileFromAssets(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Z

    .line 301
    :goto_0
    return-object v0

    .line 298
    :cond_1
    const/4 v5, 0x1

    invoke-static {v5}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object v5

    invoke-direct {p0, p1, v0, v5}, Lcom/dygame/common/DYShareMgr$DYShareHandlerDemo;->retrieveFileFromPath(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Boolean;)V

    goto :goto_0
.end method

.method private retrieveFileFromAssets(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Z
    .locals 8
    .param p1, "context"    # Landroid/content/Context;
    .param p2, "fileName"    # Ljava/lang/String;
    .param p3, "path"    # Ljava/lang/String;

    .prologue
    .line 182
    const/4 v0, 0x0

    .line 185
    .local v0, "bRet":Z
    :try_start_0
    new-instance v2, Ljava/io/File;

    invoke-direct {v2, p3}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    .line 186
    .local v2, "file":Ljava/io/File;
    invoke-virtual {v2}, Ljava/io/File;->exists()Z

    move-result v7

    if-eqz v7, :cond_0

    .line 187
    invoke-virtual {v2}, Ljava/io/File;->delete()Z

    .line 190
    :cond_0
    invoke-virtual {p1}, Landroid/content/Context;->getAssets()Landroid/content/res/AssetManager;

    move-result-object v7

    invoke-virtual {v7, p2}, Landroid/content/res/AssetManager;->open(Ljava/lang/String;)Ljava/io/InputStream;

    move-result-object v5

    .line 191
    .local v5, "is":Ljava/io/InputStream;
    invoke-virtual {v2}, Ljava/io/File;->getParentFile()Ljava/io/File;

    move-result-object v7

    invoke-virtual {v7}, Ljava/io/File;->exists()Z

    move-result v7

    if-nez v7, :cond_1

    .line 192
    invoke-virtual {v2}, Ljava/io/File;->getParentFile()Ljava/io/File;

    move-result-object v7

    invoke-virtual {v7}, Ljava/io/File;->mkdirs()Z

    .line 195
    :cond_1
    invoke-virtual {v2}, Ljava/io/File;->createNewFile()Z

    .line 196
    new-instance v3, Ljava/io/FileOutputStream;

    invoke-direct {v3, v2}, Ljava/io/FileOutputStream;-><init>(Ljava/io/File;)V

    .line 198
    .local v3, "fos":Ljava/io/FileOutputStream;
    const/16 v7, 0x400

    new-array v6, v7, [B

    .line 199
    .local v6, "temp":[B
    const/4 v4, 0x0

    .line 200
    .local v4, "i":I
    :goto_0
    invoke-virtual {v5, v6}, Ljava/io/InputStream;->read([B)I

    move-result v4

    if-lez v4, :cond_2

    .line 201
    const/4 v7, 0x0

    invoke-virtual {v3, v6, v7, v4}, Ljava/io/FileOutputStream;->write([BII)V
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    .line 209
    .end local v2    # "file":Ljava/io/File;
    .end local v3    # "fos":Ljava/io/FileOutputStream;
    .end local v4    # "i":I
    .end local v5    # "is":Ljava/io/InputStream;
    .end local v6    # "temp":[B
    :catch_0
    move-exception v1

    .line 210
    .local v1, "e":Ljava/io/IOException;
    invoke-virtual {v1}, Ljava/io/IOException;->printStackTrace()V

    .line 213
    .end local v1    # "e":Ljava/io/IOException;
    :goto_1
    return v0

    .line 204
    .restart local v2    # "file":Ljava/io/File;
    .restart local v3    # "fos":Ljava/io/FileOutputStream;
    .restart local v4    # "i":I
    .restart local v5    # "is":Ljava/io/InputStream;
    .restart local v6    # "temp":[B
    :cond_2
    :try_start_1
    invoke-virtual {v3}, Ljava/io/FileOutputStream;->close()V

    .line 205
    invoke-virtual {v5}, Ljava/io/InputStream;->close()V
    :try_end_1
    .catch Ljava/io/IOException; {:try_start_1 .. :try_end_1} :catch_0

    .line 207
    const/4 v0, 0x1

    goto :goto_1
.end method

.method private retrieveFileFromPath(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Boolean;)V
    .locals 7
    .param p1, "srcFile"    # Ljava/lang/String;
    .param p2, "dstFile"    # Ljava/lang/String;
    .param p3, "rewrite"    # Ljava/lang/Boolean;

    .prologue
    .line 219
    new-instance v4, Ljava/io/File;

    invoke-direct {v4, p1}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    .line 220
    .local v4, "fromFile":Ljava/io/File;
    new-instance v5, Ljava/io/File;

    invoke-direct {v5, p2}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    .line 221
    .local v5, "toFile":Ljava/io/File;
    invoke-virtual {v4}, Ljava/io/File;->exists()Z

    move-result v6

    if-nez v6, :cond_1

    .line 261
    :cond_0
    :goto_0
    return-void

    .line 225
    :cond_1
    invoke-virtual {v4}, Ljava/io/File;->isFile()Z

    move-result v6

    if-eqz v6, :cond_0

    .line 229
    invoke-virtual {v4}, Ljava/io/File;->canRead()Z

    move-result v6

    if-eqz v6, :cond_0

    .line 233
    invoke-virtual {v5}, Ljava/io/File;->getParentFile()Ljava/io/File;

    move-result-object v6

    invoke-virtual {v6}, Ljava/io/File;->exists()Z

    move-result v6

    if-nez v6, :cond_2

    .line 234
    invoke-virtual {v5}, Ljava/io/File;->getParentFile()Ljava/io/File;

    move-result-object v6

    invoke-virtual {v6}, Ljava/io/File;->mkdirs()Z

    .line 237
    :cond_2
    invoke-virtual {v5}, Ljava/io/File;->exists()Z

    move-result v6

    if-eqz v6, :cond_3

    .line 238
    invoke-virtual {p3}, Ljava/lang/Boolean;->booleanValue()Z

    move-result v6

    if-eqz v6, :cond_0

    .line 239
    invoke-virtual {v5}, Ljava/io/File;->delete()Z

    .line 246
    :cond_3
    :try_start_0
    new-instance v2, Ljava/io/FileInputStream;

    invoke-direct {v2, v4}, Ljava/io/FileInputStream;-><init>(Ljava/io/File;)V

    .line 248
    .local v2, "fosfrom":Ljava/io/FileInputStream;
    new-instance v3, Ljava/io/FileOutputStream;

    invoke-direct {v3, v5}, Ljava/io/FileOutputStream;-><init>(Ljava/io/File;)V

    .line 249
    .local v3, "fosto":Ljava/io/FileOutputStream;
    const/16 v6, 0x400

    new-array v0, v6, [B

    .line 252
    .local v0, "bt":[B
    :goto_1
    invoke-virtual {v2, v0}, Ljava/io/FileInputStream;->read([B)I

    move-result v1

    .local v1, "c":I
    if-lez v1, :cond_4

    .line 253
    const/4 v6, 0x0

    invoke-virtual {v3, v0, v6, v1}, Ljava/io/FileOutputStream;->write([BII)V

    goto :goto_1

    .line 258
    .end local v0    # "bt":[B
    .end local v1    # "c":I
    .end local v2    # "fosfrom":Ljava/io/FileInputStream;
    .end local v3    # "fosto":Ljava/io/FileOutputStream;
    :catch_0
    move-exception v6

    goto :goto_0

    .line 256
    .restart local v0    # "bt":[B
    .restart local v1    # "c":I
    .restart local v2    # "fosfrom":Ljava/io/FileInputStream;
    .restart local v3    # "fosto":Ljava/io/FileOutputStream;
    :cond_4
    invoke-virtual {v2}, Ljava/io/FileInputStream;->close()V

    .line 257
    invoke-virtual {v3}, Ljava/io/FileOutputStream;->close()V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0
.end method


# virtual methods
.method public doInit(Ljava/lang/String;)V
    .locals 1
    .param p1, "param"    # Ljava/lang/String;

    .prologue
    .line 83
    invoke-static {p0}, Lorg/cocos2dx/lib/Cocos2dxHelper;->addOnActivityResultListener(Landroid/preference/PreferenceManager$OnActivityResultListener;)V

    .line 86
    iget v0, p0, Lcom/dygame/common/DYShareMgr$DYShareHandlerDemo;->mListener:I

    invoke-static {p1, v0}, Lcom/dygame/common/DYShareMgr;->onInitSucc(Ljava/lang/String;I)V

    .line 87
    const/4 v0, -0x1

    iput v0, p0, Lcom/dygame/common/DYShareMgr$DYShareHandlerDemo;->mListener:I

    .line 88
    return-void
.end method

.method public doShare(Ljava/lang/String;)V
    .locals 10
    .param p1, "param"    # Ljava/lang/String;

    .prologue
    .line 107
    const/4 v1, 0x0

    .line 109
    .local v1, "jObj":Lorg/json/JSONObject;
    :try_start_0
    new-instance v2, Lorg/json/JSONObject;

    invoke-direct {v2, p1}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_1

    .line 110
    .end local v1    # "jObj":Lorg/json/JSONObject;
    .local v2, "jObj":Lorg/json/JSONObject;
    :try_start_1
    const-string v7, "method"

    const-string v8, ""

    invoke-virtual {v2, v7, v8}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    .line 112
    .local v3, "method":Ljava/lang/String;
    const-string v7, "content"

    invoke-virtual {v2, v7}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    .line 113
    .local v4, "shareContent":Ljava/lang/String;
    const-string v7, "imgpath"

    invoke-virtual {v2, v7}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v7

    invoke-direct {p0, v7}, Lcom/dygame/common/DYShareMgr$DYShareHandlerDemo;->getShareFilePath(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v5

    .line 114
    .local v5, "shareFilePath":Ljava/lang/String;
    const-string v7, "title"

    sget-object v8, Lcom/dygame/common/DYGame;->theActivity:Lcom/dygame/common/DYGame;

    const v9, 0x7f060023

    invoke-virtual {v8, v9}, Lcom/dygame/common/DYGame;->getString(I)Ljava/lang/String;

    move-result-object v8

    invoke-virtual {v2, v7, v8}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v6

    .line 116
    .local v6, "shareTitle":Ljava/lang/String;
    const-string v7, "weixin"

    invoke-virtual {v3, v7}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v7

    if-eqz v7, :cond_0

    .line 117
    invoke-direct {p0, v6, v4, v5}, Lcom/dygame/common/DYShareMgr$DYShareHandlerDemo;->doShareWeixin(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    :goto_0
    move-object v1, v2

    .line 131
    .end local v2    # "jObj":Lorg/json/JSONObject;
    .end local v3    # "method":Ljava/lang/String;
    .end local v4    # "shareContent":Ljava/lang/String;
    .end local v5    # "shareFilePath":Ljava/lang/String;
    .end local v6    # "shareTitle":Ljava/lang/String;
    .restart local v1    # "jObj":Lorg/json/JSONObject;
    :goto_1
    return-void

    .line 119
    .end local v1    # "jObj":Lorg/json/JSONObject;
    .restart local v2    # "jObj":Lorg/json/JSONObject;
    .restart local v3    # "method":Ljava/lang/String;
    .restart local v4    # "shareContent":Ljava/lang/String;
    .restart local v5    # "shareFilePath":Ljava/lang/String;
    .restart local v6    # "shareTitle":Ljava/lang/String;
    :cond_0
    const-string v7, "weibo"

    invoke-virtual {v3, v7}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v7

    if-eqz v7, :cond_1

    .line 120
    invoke-direct {p0, v6, v4, v5}, Lcom/dygame/common/DYShareMgr$DYShareHandlerDemo;->doShareWeibo(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_0

    goto :goto_0

    .line 126
    .end local v3    # "method":Ljava/lang/String;
    .end local v4    # "shareContent":Ljava/lang/String;
    .end local v5    # "shareFilePath":Ljava/lang/String;
    .end local v6    # "shareTitle":Ljava/lang/String;
    :catch_0
    move-exception v0

    move-object v1, v2

    .line 127
    .end local v2    # "jObj":Lorg/json/JSONObject;
    .local v0, "e":Ljava/lang/Exception;
    .restart local v1    # "jObj":Lorg/json/JSONObject;
    :goto_2
    iget v7, p0, Lcom/dygame/common/DYShareMgr$DYShareHandlerDemo;->mListener:I

    invoke-static {p1, v7}, Lcom/dygame/common/DYShareMgr;->onShareFail(Ljava/lang/String;I)V

    .line 128
    const/4 v7, -0x1

    iput v7, p0, Lcom/dygame/common/DYShareMgr$DYShareHandlerDemo;->mListener:I

    goto :goto_1

    .line 123
    .end local v0    # "e":Ljava/lang/Exception;
    .end local v1    # "jObj":Lorg/json/JSONObject;
    .restart local v2    # "jObj":Lorg/json/JSONObject;
    .restart local v3    # "method":Ljava/lang/String;
    .restart local v4    # "shareContent":Ljava/lang/String;
    .restart local v5    # "shareFilePath":Ljava/lang/String;
    .restart local v6    # "shareTitle":Ljava/lang/String;
    :cond_1
    :try_start_2
    invoke-direct {p0, v6, v4, v5}, Lcom/dygame/common/DYShareMgr$DYShareHandlerDemo;->doShareDefault(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    :try_end_2
    .catch Ljava/lang/Exception; {:try_start_2 .. :try_end_2} :catch_0

    goto :goto_0

    .line 126
    .end local v2    # "jObj":Lorg/json/JSONObject;
    .end local v3    # "method":Ljava/lang/String;
    .end local v4    # "shareContent":Ljava/lang/String;
    .end local v5    # "shareFilePath":Ljava/lang/String;
    .end local v6    # "shareTitle":Ljava/lang/String;
    .restart local v1    # "jObj":Lorg/json/JSONObject;
    :catch_1
    move-exception v0

    goto :goto_2
.end method

.method public init(Ljava/lang/String;I)V
    .locals 2
    .param p1, "param"    # Ljava/lang/String;
    .param p2, "listener"    # I

    .prologue
    .line 71
    iget v0, p0, Lcom/dygame/common/DYShareMgr$DYShareHandlerDemo;->mListener:I

    const/4 v1, -0x1

    if-eq v0, v1, :cond_0

    .line 72
    invoke-static {p1, p2}, Lcom/dygame/common/DYShareMgr;->onInitFail(Ljava/lang/String;I)V

    .line 78
    :goto_0
    return-void

    .line 76
    :cond_0
    iput p2, p0, Lcom/dygame/common/DYShareMgr$DYShareHandlerDemo;->mListener:I

    .line 77
    sget-object v0, Lcom/dygame/common/DYShareMgr$DYShareHandlerDemo;->mInstance:Lcom/dygame/common/DYShareMgr$DYShareHandlerDemo;

    const-string v1, "doInit"

    invoke-static {v0, v1, p1}, Lcom/dygame/common/DYThreadHelper;->runOnUIThread(Ljava/lang/Object;Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_0
.end method

.method public onActivityResult(IILandroid/content/Intent;)Z
    .locals 2
    .param p1, "requestCode"    # I
    .param p2, "resultCode"    # I
    .param p3, "data"    # Landroid/content/Intent;

    .prologue
    .line 307
    sget v0, Lcom/dygame/common/DYConst;->REQ_CODE_DEFAULT:I

    if-eq p1, v0, :cond_0

    sget v0, Lcom/dygame/common/DYConst;->REQ_CODE_WEIXIN:I

    if-eq p1, v0, :cond_0

    sget v0, Lcom/dygame/common/DYConst;->REQ_CODE_WEIBO:I

    if-eq p1, v0, :cond_0

    .line 308
    const/4 v0, 0x0

    .line 315
    :goto_0
    return v0

    .line 312
    :cond_0
    const-string v0, ""

    iget v1, p0, Lcom/dygame/common/DYShareMgr$DYShareHandlerDemo;->mListener:I

    invoke-static {v0, v1}, Lcom/dygame/common/DYShareMgr;->onShareSucc(Ljava/lang/String;I)V

    .line 313
    const/4 v0, -0x1

    iput v0, p0, Lcom/dygame/common/DYShareMgr$DYShareHandlerDemo;->mListener:I

    .line 315
    const/4 v0, 0x1

    goto :goto_0
.end method

.method public share(Ljava/lang/String;I)V
    .locals 2
    .param p1, "param"    # Ljava/lang/String;
    .param p2, "listener"    # I

    .prologue
    .line 93
    iget v0, p0, Lcom/dygame/common/DYShareMgr$DYShareHandlerDemo;->mListener:I

    const/4 v1, -0x1

    if-eq v0, v1, :cond_0

    .line 94
    invoke-static {p1, p2}, Lcom/dygame/common/DYShareMgr;->onShareFail(Ljava/lang/String;I)V

    .line 100
    :goto_0
    return-void

    .line 98
    :cond_0
    iput p2, p0, Lcom/dygame/common/DYShareMgr$DYShareHandlerDemo;->mListener:I

    .line 99
    sget-object v0, Lcom/dygame/common/DYShareMgr$DYShareHandlerDemo;->mInstance:Lcom/dygame/common/DYShareMgr$DYShareHandlerDemo;

    const-string v1, "doShare"

    invoke-static {v0, v1, p1}, Lcom/dygame/common/DYThreadHelper;->runOnUIThread(Ljava/lang/Object;Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_0
.end method
